// Importation des librairies
import processing.video.*;

// Parametres de taille de la capture video
final int widthCapture=640;
final int heightCapture=480;
final int numPixels=widthCapture*heightCapture;
final int fpsCapture=30;

// Pour la sauvegarde du point précédent:
int sXPOI, sYPOI;
boolean methodeONE;
boolean seuille_img;
int countFrame;

// Declaration des variables globales
String[] cameras;
Capture webCam;
PImage img;

// masques pour contours
PImage img_modifiee;
float[][] contours_horizontal = {{-1, 0, 1}};
float[][] contours_vertical = {{-1}, {0}, {1}};

// Fonction d'initialisation:
void setup() {
  // Initialisation des parametres graphiques:
  size(640,480);
  surface.setTitle("Webcam RA");

  // remplissage et couleur:
  noFill();
  stroke(#FF0000);
  //colorMode(HSB, 360, 100, 100);

  methodeONE = true;
  seuille_img = false;
  
  // Recherche d'une webcam 
  cameras = Capture.list();
  if (0 == cameras.length) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Initialisation de la webcam Video par defaut
    webCam = new Capture(this, widthCapture, heightCapture, cameras[0], fpsCapture);
    // webCam = new Capture(this, widthCapture, heightCapture, "Logitech HD Webcam C310", fpsCapture);
    webCam.start();
  }
  img_modifiee = createImage(webCam.width, webCam.height, RGB);
}


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  // Indices et coordonnées:
  int i;
  int xx, yy;
  int yPos;
  // Coordonnees du Point d'interet  : Point Of Interest
  int xPOI, yPOI;
  float poids, poidsPOI;
  // Coordonnees de l'image:
  int xImg, yImg;

  // Couleur et saturation:
  color currColor;
  float teinte;
  float sat;

  countFrame = (countFrame + 1) % 10;

  
  if (webCam.available() == true) {
    webCam.read();
    
    // Recherche du point le plus proche de la couleur de reference
    poidsPOI = 360;
    xPOI = 0; yPOI = 0;

    // Analyse de l'image:
    for (yy = 0; yy < heightCapture; yy++) {
      yPos = yy * widthCapture; 
      for (xx = 0; xx < widthCapture; xx++) {
      i = xx + yPos;
        currColor = webCam.pixels[i];

	// Récupération de la teinte et de la saturation du pixel
        //teinte = hue(currColor);
        teinte = green(currColor);
        // sat = saturation(currColor);

	// Mise à jour des coordonnées si la souleur et la saturation correspondes:
        //poids = abs(120-teinte);
        poids = teinte;
        if (poids < poidsPOI) {
          poidsPOI = poids;
          xPOI = xx;
          yPOI = yy;
        }
      }
    }

    // Partie imagerie:
    if (methodeONE) {
      // multiplication (proportion):
      float[][] h = multiply2D(contours_horizontal, abs(xPOI - sXPOI));
      convolution(webCam, img_modifiee, h);
      float[][] v = multiply2D(contours_horizontal, abs(yPOI - sYPOI));
      convolution(webCam, img_modifiee, v);
    } else {
      if (abs(xPOI - sXPOI) > 5 && abs(yPOI - sYPOI) < 5) {
        convolution(webCam, img_modifiee, contours_horizontal);
      } else if (abs(xPOI - sXPOI) < 5 && abs(yPOI - sYPOI) > 5) {
        convolution(webCam, img_modifiee, contours_vertical);
      } else if (abs(xPOI - sXPOI) > 5 && abs(yPOI - sYPOI) > 5) {
        gradient(webCam, img_modifiee);
      } else {
        img_modifiee.copy(webCam, 0, 0, 640, 480, 0, 0, 640, 480);
      }
    }
    if (seuille_img) {
      seuillage(img_modifiee, img_modifiee, 100);
    }

    // Restitution de l'image et application des modifications:
    image(img_modifiee, 0, 0);

    // sauvegarde des valeurs pour le prochain tours:
    if (countFrame == 0) { // mise à jour toutes les 10 frames
      sXPOI = xPOI;
      sYPOI = yPOI;
    }
  }
}


void keyPressed() {
  switch (key) {
  case 'a': 
    methodeONE = true;
    break;
  case 'b': 
    methodeONE = false;
    break;
  case 's': 
    seuille_img = !seuille_img;
    break;
  } 
}


// Fonction appelee lors de la fermeture de la fenetre windows
// par un clic sur la croix de fermeture de la fenetre...
void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.stop(); // Arret "propre" de la webcam
  super.exit();
}


// take two dim array and float x and return arr * x:
float[][] multiply2D(float[][] table, int x) {
  float[][] output = new float[table.length][];
  for (int i = 0; i < table.length; ++i) {
    output[i] = new float[table[i].length];
  }
  for (int i = 0; i < table.length; ++i)  {
    for (int j = 0; j < table[i].length; ++j) {
      output[i][j] = table[i][j] * x;
    }
  }
  return output;
}
