// Importation des librairies
import processing.video.*; // Bibliotheque de controle camera
import java.util.*;
// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Declaration de la Capture par Camera



color couleurRect;

//Paramètres de filtrage
float[][] lissage = { { 1./9.,1./9.,1./9. },
                    { 1./9.,1./9.,1./9. },
                    { 1./9.,1./9.,1/9. } }; 
PImage img_lissee;  // image lissée
PImage contours; //image seuillée des contours
PImage gradient;  // image de la norme du gradient
PImage orientation;

int seuil_haut = 120;
int seuil_bas = 20;
int thresholdHough= 80;

// Paramètres seuillage
int seuil = 60;



void setup(){
  size(640, 480);
  couleurRect = color(247, 241, 27, 100);
  fill(couleurRect);
  stroke(#FF0000);
  strokeWeight(5);
  
  
  // Recherche d'une webcam 
  cameras = Capture.list();
  if (0 == cameras.length) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Initialisation de la webcam Video par defaut
    webCam = new Capture(this, widthCapture, heightCapture, cameras[0], fpsCapture);
    // webCam = new Capture(this, widthCapture, heightCapture, "Logitech HD Webcam C310", fpsCapture);
    webCam.start(); // Mise en marche de la webCam
  }
  
  // Initialisation des images
  img_lissee = createImage(webCam.width, webCam.height, RGB);
  gradient = createImage(webCam.width, webCam.height, RGB);
  contours = createImage(webCam.width, webCam.height, RGB);
  orientation = createImage(webCam.width, webCam.height, RGB);
  
}

void draw(){

  
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
    image(webCam, 0, 0); // Restitution de l'image captee sur la webCam   
    
    // Calcul des gradients et contours
    compute_contours(webCam, img_lissee, gradient, contours); // Calcul des contours 
    
    if (mousePressed && (mouseButton == RIGHT)) { // Test clic droit de la souris...
      // Affichage de l'image des gradients
      image(gradient,0,0);
    }
    else if (mousePressed && (mouseButton == LEFT)){// Test clic gauche de la souris...
      // Affichage de l'image des contours
      image(contours,0,0);
    }
    else{
     // Affichage de l'image de la Webcam
      image(webCam,0,0);
    }
    
    
    // Transformée de Hough
    int [][] tab = compute_hough(contours,1,1);
    //Parcours de l'accumulateur pour récupérer les principales lignes
    Vector<droite> lines = compute_hough_lines(tab, thresholdHough);
    
    //On recupere la ligne principale:
    droite mainLine = lines.get(0);
    for(int i=1; i<lines.size(); i++){
      if(mainLine.acc < lines.get(i).acc){
          mainLine = lines.get(i);
      }
    }
    
    //On affiche cette ligne:
    mainLine.display(#FF0000, width, height);
    
    //On recupere son angle: mainLine.theta
    translate(width/2, height/2);
    rotate( radians(mainLine.theta) );
    rect(-75, -50, 150, 100);
    
  }
}
