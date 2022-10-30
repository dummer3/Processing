// Importation des librairies
import processing.video.*; // Bibliotheque de controle camera

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Declaration de la Capture par Camera



color couleurRect;
int deltaX, deltaY;
boolean premierDraw = true;
int ancienX, ancienY;
void setup(){
  size(640, 480);
  couleurRect = color(247, 241, 27, 100);
  fill(couleurRect);
  stroke(#FF0000);
  strokeWeight(5);
  deltaX = 0;
  deltaY = 0;
  
  colorMode(HSB, 360, 100, 100); // Passage en mode HSB pour Couleur avec teinte
  
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
  
}

void draw(){
  int i; // Index du vecteur image...
  int xx, yy; // ... equivalent aux coordonnees matriciels xx et yy
  int yPos; // Decalage offset de la composante y
  color currColor; // Couleur du pixel courant...
  float teinte; // Teinte (hue) dans cette couleur
  
  int xPOI, yPOI; // Coordonnees du Point d'interet  : Point Of Interest
  float poids, poidsPOI; // Ecart entre les differences teinte (et le vert pur)
  
    if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
      webCam.read(); // Lecture du flux sur la camera... lecture d'une frame
      
      // Recherche du point le plus proche de la couleur de reference
      poidsPOI = 360; // Valeur la plus grande possible, en distance Euclidienne
      xPOI = 0; yPOI = 0;   // Par defaut, le POI est en (0,0)
  
      // Analyse de l'image
      for (yy = 0; yy < heightCapture; yy++) { // abscisse yy
        yPos = yy * widthCapture; 
        for (xx = 0; xx < widthCapture; xx++) { // ordonnees xx
          i = xx + yPos;
          currColor = webCam.pixels[i]; // recuperation couleur
          teinte = hue(currColor); // et de la teinte
          // Calcul de l'ecart de teinte par rapport au vert pur
          poids = abs(355-teinte); // car vert pur = 120 degre
          if (poids < poidsPOI) {  // Le POI est le point qui a le moins de difference...
            poidsPOI = poids; // Mise a jour des informations et coordonnees
            xPOI = xx;
            yPOI = yy;
          }
        }
      }
      image(webCam, 0, 0);

      translate(xPOI, yPOI );
      rect(-150/2, -50, 150, 100);
    }
  
}
