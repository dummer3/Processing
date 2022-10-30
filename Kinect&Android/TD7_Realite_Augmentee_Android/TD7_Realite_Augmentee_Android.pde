/****************************************************************************/
/*  MESNARD Emmanuel                                              ISIMA     */
/*                                                                          */
/*        Utilisation d'une des cameras (avec Ketai) sous Android           */
/*  infos supplementaires : http://ketai.org/reference/camera/ketaicamera/  */
/*                                                                          */
/* TD7_Realite_Augmentee_Android.pde         Processing 3.5.4 - ANDROID   */
/****************************************************************************/

// Import bibliotheques
import ketai.camera.*;
import jp.nyatla.nyar4psg.*;

// Declaration des variables globales
KetaiCamera cam; // Camera
int nbCamera;
Boolean plusieursCamera;
PImage ImageCourante;

// Scene de RA
MultiMarker sceneMM;
Boolean refreshWebcam;

// Gestion de l'objet
PShape objetOBJ;        // Objet a charger
float dimOBJ_X, dimOBJ_Y, dimOBJ_Z; // Dimensions de l'objet
float facteurEchelle;  // Mise a l'echelle pour un meilleur rendu


// Analyse complementaire pour determiner la position du repere dans l'objet
// -------------------------------------------------------------------------
PShape partieObj; // Analyse de l'objet par morceaux (enfants dans un objet)
int nombreEnfant;
int nombreVertex, nombreVertexTotal; // Nombres de Vertex
// Amplitudes de l'objet, initialisees aux extremes opposes
float minX = 3.40282347E+38; // min et max sur les 3 dimensions
float minY = 3.40282347E+38;
float minZ = 3.40282347E+38;
float maxX = -3.40282347E+38;
float maxY = -3.40282347E+38;
float maxZ = -3.40282347E+38;
// Coordonnees du vertex en cours de traitement
float vX, vY, vZ;
// Decalage a appliquer pour positionner correctement l'objet
float decX, decY, decZ;

// Indices des boucles
int i, j;


// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  fullScreen(P3D); // Pour le referentiel complet en 3D => P3D
  orientation(LANDSCAPE); // Forcage du mode, evitant l'auto rotate qui redemarre l'app

  // Gestion du mode d'affichage
  imageMode(CENTER); // Mode centre pour garantir que l’image sera visible
  textAlign(CENTER, CENTER);
  textSize(displayDensity * 25);

  // Ouverture du systeme de gestion des cameras a 24 fps 
  cam = new KetaiCamera(this, 640, 480, 24);
  if (cam != null) {
    nbCamera = cam.getNumberOfCameras();
    plusieursCamera = (nbCamera>1);
  }

  // Creation de la scene de recherche des multi marqueurs
  sceneMM = new MultiMarker(this, 640, 480, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  sceneMM.setARClipping(100, 20000); // Gestion du Clipping pour eviter la coupure des objets
  sceneMM.addARMarker("Marqueur_ISIMA.patt", 80); // Marqueur numero 0
  refreshWebcam = false;

  // Chargement de l'objet utilise
  objetOBJ = loadShape("Dog_Isima.obj"); // Avec image de texture

  // Analyse de l'objet pour determiner la position du repere
  nombreVertex = objetOBJ.getVertexCount();
  nombreVertexTotal = nombreVertex;
  if (nombreVertex>0) {
    for (i=0; i<nombreVertex; i++) {
      vX = objetOBJ.getVertexX(i);
      vY = objetOBJ.getVertexY(i);
      vZ = objetOBJ.getVertexZ(i);
      if (vX<minX) minX=vX; 
      else if (vX>maxX) maxX=vX; 
      if (vY<minY) minY=vY; 
      else if (vY>maxY) maxY=vY; 
      if (vZ<minZ) minZ=vZ; 
      else if (vZ>maxZ) maxZ=vZ;
    }
  } 

  nombreEnfant = objetOBJ.getChildCount();
  //println("Nombre d'enfants : "+nombreEnfant);
  if (nombreEnfant>0) {
    for (i=0; i<nombreEnfant; i++) {
      // Analyse pour chaque enfant
      partieObj = objetOBJ.getChild(i);
      nombreVertex = partieObj.getVertexCount();
      nombreVertexTotal +=nombreVertex;
      if (nombreVertex>0) {
        for (j=0; j<nombreVertex; j++) {
          vX = partieObj.getVertexX(j);
          vY = partieObj.getVertexY(j);
          vZ = partieObj.getVertexZ(j);
          if (vX<minX) minX=vX; 
          else if (vX>maxX) maxX=vX; 
          if (vY<minY) minY=vY; 
          else if (vY>maxY) maxY=vY; 
          if (vZ<minZ) minZ=vZ; 
          else if (vZ>maxZ) maxZ=vZ;
        }
      }
    }
  }

  println("Nombre total de vertex dans l'objet : " + nombreVertexTotal);
  println("Coordonnees min : " + minX + "  " + minY + "  " + minZ);
  println("Coordonnees MAX : " + maxX + "  " + maxY + "  " + maxZ);

  // Determination de la taille effective de l'objet
  dimOBJ_X = maxX-minX;  // dimOBJ_X = objetOBJ.getWidth();
  dimOBJ_Y = maxY-minY;  // dimOBJ_Y = objetOBJ.getHeight();
  dimOBJ_Z = maxZ-minZ;  // dimOBJ_Z = objetOBJ.getDepth();
  println("Taille Objet : " + dimOBJ_X + ", " + dimOBJ_Y + ", " + dimOBJ_Z);

  decX = -minX - dimOBJ_X/2.0f;
  decY = -minY - dimOBJ_Y/2.0f;
  decZ = -minZ - dimOBJ_Z/2.0f;
  println("Translations a appliquer pour centrer l'objet : " + decX + "  " + decY + "  " + decZ);


  // Calcul du facteur d'echelle pour affichage "correct" a l'ecran, sur la largeur
  // en proportion de la taille du marqueur (1.4 fois la taille du marqueur)
  facteurEchelle = 1.4f * width /(min(dimOBJ_X, dimOBJ_Y, dimOBJ_Z)*80); 
  objetOBJ.scale(facteurEchelle);

  println("Facteur d'Echelle pour rendu 640x480 : " + facteurEchelle);

  // Mise a jour des dimensions de l'objet et des decalages associes
  dimOBJ_X *= facteurEchelle;
  dimOBJ_Y *= facteurEchelle;
  dimOBJ_Z *= facteurEchelle;

  decX*= facteurEchelle;
  decY*= facteurEchelle;
  decZ*= facteurEchelle;
  println("Nouvelle taille Objet : " + dimOBJ_X + ", " + dimOBJ_Y + ", " + dimOBJ_Z);

  // Application des translations ainsi calculees pour recentrage
  // A noter, si l'origine de l'objet est en bas a droite au fond, alors
  // equivalent a : objetOBJ.translate(dimOBJ_X/2, -dimOBJ_Y/2, -dimOBJ_Z/2);
  objetOBJ.translate(decX, decY, decZ);
} // fin de setup


void draw() {
  if (cam != null && cam.isStarted()) {
    // La camera fonctionne correctement

    if (refreshWebcam) {
      refreshWebcam = false;

      // restitution en plein ecran, centree
      image(cam, width/2, height/2, width, height);

      // Recherche du marqueur dans la scene
      cam.updatePixels();
      sceneMM.detect(cam);
      if (sceneMM.isExist(0)) { // Dessin objet si marqueur trouve
        sceneMM.beginTransform(0); 
        shape(objetOBJ);
        sceneMM.endTransform();
      }
    }
  } else {
    // Elle est eteinte (ou absente...)
    background(#D16363);
    text("!! Camera eteinte !!", width/2, height/2);
  }
  // Ajout des boutons
  affichageBoutons();
}

void onCameraPreviewEvent() {
  cam.read(); // Lecture d'une image
  refreshWebcam = true;
}

void mousePressed() {
  // Analyse des boutons appuyes

  if (mouseY < 100) {
    // On ne regarde que dans le bandeau Haut

    if (mouseX < width/3) {
      // Premier tiers : Camera on/off
      if (cam.isStarted()) {
        cam.stop();
      } else {
        cam.start();
      }
    } else if (plusieursCamera && (mouseX > width/3) && (mouseX < 2*width/3)) {
      // Second tiers : changement de camera
      cam.setCameraID((cam.getCameraID() + 1 ) % nbCamera);
    } else if (mouseX > 2*width/3) {
      // Dernier tiers :  Flash Camera on/off
      if (cam.isFlashEnabled()) {
        cam.disableFlash();
      } else {
        cam.enableFlash();
      }
    }
  }
}

void affichageBoutons() { // Affichage de l'interface utilisateur
  pushStyle(); // Conservation du style d'ecriture
  textAlign(LEFT);
  fill(0);
  stroke(255);

  // Dessin des boutons
  rect(0, 0, width/3, 100);
  if (plusieursCamera) {
    rect(width/3, 0, width/3, 100);
  }
  rect((width/3)*2, 0, width/3, 100);

  // Affichage des textes sur les boutons
  fill(255);
  if (cam.isStarted()) {
    text("Camera Off", 5, 80);
  } else {
    text("Camera On", 5, 80);
  }

  if (plusieursCamera) {
    text("Switch Camera", width/3 + 5, 80);
  }

  if (cam.isFlashEnabled()) {
    text("Flash Off", width/3*2 + 5, 80);
  } else {
    text("Flash On", width/3*2 + 5, 80);
  }
  popStyle();
}

// Fonctions de gestion des evenements de la souris et du clavier
void mouseDragged() { // Fonction invoquee tant que le bouton est maintenu appuye 
  // Ajout d'une rotation en X et en Y selon le deplacement de la souris
  objetOBJ.rotateX((pmouseY-mouseY) /100.0);
  objetOBJ.rotateY((mouseX-pmouseX) /100.0);
}
