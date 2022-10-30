/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Exemple 6 : Realite Augmentee par ARtoolkit et Webcam           */
/*                      avec marqueur de type NFT                           */
/*                                                                          */
/* Exemple_6_RA_NFT.pde                                Processing 3.5.4     */
/****************************************************************************/

// Importation des librairies
import processing.video.*;     // Bibliotheque de controle camera
import jp.nyatla.nyar4psg.*;   // ARToolKit (version 3.0.7)
import MD2Importer.*;

// Parametres de taille de la capture video
final int widthCapture=1000;  // largeur capture
final int heightCapture=680; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Camera 
MultiNft sceneNFT;   // Scene de recherche de "multi-marqueur"

PShape[] ensembleShape = new PShape[4];
int indice;
PImage[] imageToFind = new PImage[4];

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(1000, 680, P3D); // ouverture en mode 3D (uniquement)
  surface.setTitle("Exemple 6 - RA NFT - E. Mesnard / ISIMA");
  noFill();
  stroke(#E802B7); // Couleur violacee
  strokeWeight(1);
  
  ensembleShape[0] = loadShape("untitled.obj");
   ensembleShape[0].scale(55);
   ensembleShape[1] = loadShape("balthasar.obj");
   ensembleShape[1] .scale(60);
     ensembleShape[2] = loadShape("piaf.obj");
   ensembleShape[2].scale(25);
     ensembleShape[3] = loadShape("pégase.obj");
   ensembleShape[3].scale(55);
  
  // Recherche d'une webcam 
  cameras = Capture.list();
  if (cameras.length == 0) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Initialisation de la webcam par defaut
    webCam = new Capture(this, widthCapture, heightCapture, cameras[0], fpsCapture);
    webCam.start(); // Mise en marche de la webCam
  }

  // Declaration de la scene de recherche avec parametres par defaut :
  // calibration de camera et systeme de coordonnees
  sceneNFT = new MultiNft(this, widthCapture, heightCapture, 
    "camera_para.dat", 
    NyAR4PsgConfig.CONFIG_PSG);

  // Declaration du marqueur a rechercher, avec sa dimension en mm
  sceneNFT.addNftTarget("spider", 80);
  sceneNFT.addNftTarget("welcomeToEstaliaGentleman", 80);
  sceneNFT.addNftTarget("piaf", 80);
  sceneNFT.addNftTarget("pegase", 80);// Marqueur numero 0
  imageToFind[0] = loadImage("arachnarok.png");
  imageToFind[1] = loadImage("WelcomeToEstaliaGentleman.jpg");
  imageToFind[1].resize(imageToFind[1].width/5,imageToFind[1].height/5);
  imageToFind[2] = loadImage("piaf.jpg");
  imageToFind[2].resize(imageToFind[2].width/6,imageToFind[2].height/6);
  imageToFind[3] = loadImage("pegasus.png");
  
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame

    webCam.read(); // Lecture du flux sur la camera... lecture d'une frame

    sceneNFT.detect(webCam);   // Recherche du marqueur dans la scene
    webCam.updatePixels();    // Mise a jour des pixels

    // Effacer la fenetre avant de dessiner l'image video "reelle"
    background(0); 
    image(webCam, 0, 0);  // Affiche l'image prise par la webCam
    text("L'image à trouver est :",10,10);
    image(imageToFind[indice],0,20);

    // Incrustation de l'image virtuelle si marqueur trouve
    if (sceneNFT.isExist(indice)) { // Marqueur ISIMA
      // Le marqueur est detecte dans le flux video
      // Changement de repere pour tracer en coordonnees "Marqueur"
      sceneNFT.beginTransform(indice); // Modification graphique sur marqueur 0
      noFill();
      // Trace du repere unitaire (X,Y,Z) en (R,G,B)
      strokeWeight(3);
      stroke(#FF0000);
      line(0,0,0,80,0,0); // Ligne rouge pour X
      stroke(#00FF00);
      line(0,0,0,0,80,0); // Ligne verte pour Y
      stroke(#0000FF);
      line(0,0,0,0,0,80); // Ligne bleu pour Z
      translate(-40,0,20);
      shape(ensembleShape[indice],0,0);
      ensembleShape[indice].rotateY(0.05);
      sceneNFT.endTransform();
      
     
      
    }
  }
}

void keyPressed() {
  println("CHANGEMENT DE PRESENTATION");
  switch(key) {
    case ' ' : indice = (indice +1)%4; 
}
}



void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.stop(); // Arret "propre" de la webcam
  super.exit();
}
