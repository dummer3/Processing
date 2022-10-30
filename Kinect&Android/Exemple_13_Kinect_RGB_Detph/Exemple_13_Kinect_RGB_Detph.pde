/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*          Kinect avec affichage des images RGB et Depth                   */
/*                                                                          */
/* Exemple_13_Kinect_RGB_Detph.pde                       Processing 3.0     */
/****************************************************************************/

// Importation des librairies
import edu.ufl.digitalworlds.j4k.*; // Gestion de la Kinect

// Declaration des variables globales
int NbCouleurs;      // Gestion des couleurs
int compteur;

PKinect kinect;   // Declaration de la Kinect

byte[] colorMap;    // Carte des valeurs des couleurs = Flux "COLOR"
PImage  colorImage; // Image RGB reconstruite equivalente
int colorW = 0;     // Largeur de l'image RGB
int colorH = 0;     // Hauteur de l'image RGB

short[] depthMap;   // Carte des profondeurs = flux "DEPTH"
PImage  depthImage; // Image equivalente aux profondeurs, en niveaux de gris
int depthW = 0;     // Largeur de l'image Depth
int depthH = 0;     // Hauteur de l'image Depth

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  // Initialisation des parametres graphiques utilises
  size(896, 336, P2D); // Haute vitesse, en proportion de 640, 240
  surface.setTitle("Exemple 13 - La Kinect RGB et Depth - E. Mesnard / ISIMA");
  surface.setResizable(true); // Fenetre re-dimensionnable
  colorMode(HSB, 360, 100, 100); // fixe format couleur R G B
  noFill(); // pas de remplissage
  background(0); // couleur fond fenetre

  // Initialisation Objet Kinect
  kinect = new PKinect(this);

  // Ouverture des flux "COLOR" et "DEPTH"
  if (kinect.start(PKinect.DEPTH|PKinect.COLOR) == false) {
    println("Pas de kinect connectee !"); 
    exit();
    return;
  } else if (kinect.isInitialized()) {
    println("Kinect de type : "+kinect.getDeviceType());
    println("Kinect initialisee avec : ");
    colorW = kinect.getColorWidth();
    colorH = kinect.getColorHeight();
    println("  * Largeur image couleur : " + colorW);
    println("  * Hauteur image couleur : " + colorH);
    depthW = kinect.getDepthWidth();
    depthH = kinect.getDepthHeight();
    println("  * Largeur image profondeur : " + depthW);
    println("  * Hauteur image profondeur : " + depthH);
  } else { 
    println("Probleme d'initialisation de la kinect");
    exit();
    return;
  }

  // Creation des objets Color et Depth
  colorMap = new byte[colorW*colorH*4];
  colorImage = createImage(colorW, colorH, RGB);
  depthMap = new short[depthW*depthH];
  depthImage = createImage(depthW, depthH, RGB);
}

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() { 
  int i, j; // Indices des boucles
  int ValZ; // Composante distance Z pour le point considere
  int mini, maxi; // Valeur Z mini non nulle et maximum

  // Recuperation d'eventuelles donnees sur la kinect...
  colorMap = kinect.getColorFrame(); // Flux "COLOR"
  depthMap = kinect.getDepthFrame(); // Flux "DEPTH"

  // Traitement du Flux "COLOR"
  // **************************
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

  // Traitement du Flux "DEPTH"
  // **************************
  if (depthMap!=null) { // Des donnees de profondeur sont disponibles

    // Recherche des profondeurs mini et maxi 
    maxi = 0; 
    mini = 100000;
    for (i=0; (i < depthH*depthW); i++) {
      if (mini>depthMap[i]) { 
        mini = depthMap[i];
      } else if (maxi < depthMap[i]) {
        maxi = depthMap[i];
      }
    }
    // println("min="+mini+"  max="+maxi); 

    // Conversion du tableau en une image de profondeur
    depthImage.loadPixels();
    for (i = 0; i < depthH*depthW; i++) {
      if (depthMap[i] == 0) { // Hors champ
        // Point trop proche, traitement particulier 
        depthImage.pixels[i] = 0;  // en Noir !
        // ou bien, distance neutre : color(128, 128, 128);
      } else {
        // Valeur proportionnelle, variant de 0 a 255
        //ValZ = (int) map((float)depthMap[i], mini, maxi,255, 0);
        ValZ = (int) depthMap[i];

        depthImage.pixels[i] = color((int) 3.6*ValZ/360-32, 100,100); // En gris
      }
    }
    depthImage.updatePixels();
  }


  // Trace de l'ensemble sur la fenetre
  // **********************************

  // Effacement de la fenetre
  background(0);

  // Affichage des deux images, cote a cote
  image(depthImage, 0, 0, width/2, height);
  image(colorImage, width/2, 0, width/2, height);

  }
