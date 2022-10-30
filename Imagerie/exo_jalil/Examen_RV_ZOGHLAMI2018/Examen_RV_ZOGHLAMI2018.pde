// Importation des librairies
import edu.ufl.digitalworlds.j4k.*; // Gestion de la Kinect


/************ KINECT *****************/
// Declaration des variables globales
PKinect kinect;   // Declaration de la Kinect
Skeleton[] s;     // Tableau des Squelettes des personnes detectees
int sMax;         // Limite de personnes pouvant etre detectees

byte[] colorMap;    // Carte des valeurs des couleurs = Flux "COLOR"
PImage  colorImage; // Image RGB reconstruite equivalente
int colorW = 0;     // Largeur de l'image RGB
int colorH = 0;     // Hauteur de l'image RGB
int widthCapture, heightCapture;
/*************************************/

int x,y;
void setup(){
  size(500, 300);
  surface.setTitle("Examen 2018 partie 1");
  background(0);
  x = int(random(width-20));
  y = int(random(height-20));
  strokeWeight(5);
  stroke(#FF0000);//Bordure rouge au départ (non selectionné)
  fill(#0000FF);
  rect(x, y, 20, 20);

  kinect = new PKinect(this);

  // Ouverture du flux "SKELETON"
  if (kinect.start(PKinect.SKELETON | PKinect.COLOR) == false) {
    println("Pas de kinect connectee !"); 
    exit();
    return;
  } else if (kinect.isInitialized()) {
    println("Kinect de type : "+kinect.getDeviceType());
    println("Kinect initialisee avec : ");
    sMax = kinect.getSkeletonCountLimit();
    println("  * Limite de personnes trackées : " + sMax);
    println("Kinect initialisee avec : ");
    colorW = kinect.getColorWidth();
    colorH = kinect.getColorHeight();
    println("  * Largeur image couleur : " + colorW);
    println("  * Hauteur image couleur : " + colorH);
  } else { 
    println("Probleme d'initialisation de la kinect");
    exit();
    return;
  }
  // Creation des objets Color 
  colorMap = new byte[colorW*colorH*4];
  colorImage = createImage(colorW, colorH, RGB);

  widthCapture = width;
  heightCapture = height;
}

void draw(){
  background(0);//"Effacement" de l'écran
  int i,j;
  
  colorMap = kinect.getColorFrame(); // Flux "COLOR"
  
  if (colorMap!=null) { // Des donnees couleur sont disponibles
    
    // Conversion du tableau en une image en couleur
    colorImage.loadPixels();
    j = 0;
    for (i = 0; i < colorMap.length; i+=4) {  
      colorImage.pixels[j] = (colorMap[i+2]&0x0000FF)<<16 |
        (colorMap[i+1]&0x0000FF)<<8  |
        (colorMap[i]&0x0000FF);
      j++;
    }
    colorImage.updatePixels();
  }
  image(colorImage, 0, 0, width, height);
  
  //L'image est affichée
  
  
  // Recuperation d'eventuelles donnees sur la kinect...
  s = kinect.getSkeletons();

  //Traitement du Flux "Skeletons"
  for (i=0; i<sMax; i++) {
    if (s[i]!=null) { // Des donnees sont disponibles
      if (s[i].isTracked()==true) { // Cet humain est actuellement visible
      
        if(s[i].isJointTracked(Skeleton.HAND_RIGHT)){
          
          int[] pos = s[i].get2DJoint(Skeleton.HAND_RIGHT, width, height); 
          color inverse = colorImage.pixels[pos[1]*width + pos[0]];
          inverse = color(255 - red(inverse), 255-green(inverse), 255-blue(inverse));
          fill(inverse);
          circle(pos[0], pos[1], 10);//Cercle servant de pointeur (main droite)
          
        }
        
        //On considere que la main gauche est levée si elle est au dessus de "spine" (colonne vertebrale ?)
        if( s[i].isJointTracked(Skeleton.SPINE_MID) && s[i].isJointTracked(Skeleton.HAND_LEFT) ){
          //Si la main gauche est tracké ainsi que la colonne vertebrale
          int[] posMainGauche = s[i].get2DJoint(Skeleton.HAND_LEFT, width, height); 
          int[] posSpine = s[i].get2DJoint(Skeleton.SPINE_MID, width, height); 
          if(posMainGauche[1] < posSpine[1]){
            //si la main gauche est levée
            int[] posMainDroite = s[i].get2DJoint(Skeleton.HAND_RIGHT, width, height);
            if(estSelectionne(x, y, 20, 20, posMainDroite[0], posMainDroite[1])){
              stroke(#00FF00);//Bordure verte
              //On fait bouger le rectangle avec la main s'il est selectionné(donc main gauche levée également)
              x = posMainDroite[0];
              y = posMainDroite[1];
            }else{
              stroke(#FF0000);//Bordure rouge
            }
          }
        }
        
      }
    }
  }
  //On affiche notre rectangle dans tout les cas
  rect(x, y, 20, 20);
  
}

boolean estSelectionne(int x, int y,int largeur, int hauteur, int selecteurX, int selecteurY){
  if(selecteurX >= x && selecteurX <= (x+largeur)){
    if(selecteurY >= y && selecteurY <= (y+hauteur)){
      //Le selecteur est à l'intereur du rectangle
      return true;
    }
  }
  return false;
}
