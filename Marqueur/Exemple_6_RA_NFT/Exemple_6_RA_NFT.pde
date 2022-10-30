

// Importation des librairies
import processing.video.*;     // Bibliotheque de controle camera
import jp.nyatla.nyar4psg.*;   // ARToolKit (version 3.0.7)

// Parametres de taille de la capture video
final int widthCapture=640;  // largeur capture
final int heightCapture=480; // hauteur capture
final int numPixels=widthCapture*heightCapture; // nombre de pixels d'une image video
final int fpsCapture=30;     // taux d’images/secondes

// Declaration des variables globales
String[] cameras;    // Liste des cameras dispos
Capture webCam;      // Camera 
MultiNft sceneNFT;   // Scene de recherche de "multi-marqueur"

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  loadShape("Necrofex.obj");
  // Initialisation des parametres graphiques utilises
  size(640, 480, P3D); // ouverture en mode 3D (uniquement)
  surface.setTitle("Exemple 6 - RA NFT - E. Mesnard / ISIMA");
  noFill();
  stroke(#E802B7); // Couleur violacee
  strokeWeight(1);

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
  sceneNFT.addNftTarget("Image_ISIMA", 80); // Marqueur numero 0
  println(MultiMarker.VERSION); // Affichage numero version en console
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

    // Incrustation de l'image virtuelle si marqueur trouve
    if (sceneNFT.isExist(0)) { // Marqueur ISIMA
      // Le marqueur est detecte dans le flux video
      // Changement de repere pour tracer en coordonnees "Marqueur"
      sceneNFT.beginTransform(0); // Modification graphique sur marqueur 0
      noFill();
      // Trace du repere unitaire (X,Y,Z) en (R,G,B)
      strokeWeight(3);
      stroke(#FF0000);
      line(0,0,0,80,0,0); // Ligne rouge pour X
      stroke(#00FF00);
      line(0,0,0,0,80,0); // Ligne verte pour Y
      stroke(#0000FF);
      line(0,0,0,0,0,80); // Ligne bleu pour Z
      sceneNFT.endTransform();
    }
  }
}

void keyPressed() {
  println(frameRate);
}

// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.stop(); // Arret "propre" de la webcam
  super.exit();
}
