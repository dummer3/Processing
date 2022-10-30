
import MD2Importer.*; // Librairie d'acces aux fichiers MD2


MD2_Loader chargeurOiseau;  // Espace memoire pour charger/decoder le fichier
MD2_Model Oiseau;           // Objet MD2 lu
MD2_ModelState[] animation; // Animations disponibles pour ce modele
float pourcentAnimation = 0.4; // Vitesse sur le rendu de l'animation  


// Fonction d'initialisation de l'application 
void setup() {
  // Initialisation des parametres graphiques utilises
  size(640,480, P3D);
  
  noStroke();
  
  // Creation du chargeur pour acceder au fichier MD2
  chargeurOiseau = new MD2_Loader(this);
  
  // Chargement effectif du modele texture
  Oiseau = chargeurOiseau.loadModel("Oiseau.md2", "Oiseau.jpg");
  
  if (Oiseau == null) {
    println("Probleme de chargement de ce fichier MD2");
    exit();
  } else {
                        
    chargeurOiseau = null; // Liberation de l'espace memoire

    // Recuperation de toutes les animations disponibles
    animation = Oiseau.getModelStates();
    
    Oiseau.centreModel();
    
    // Mise a l'echelle souhaitee de l'objet MD2
    Vector3 dimensionOiseau = new Vector3();
    dimensionOiseau = Oiseau.getModSize();
    // println("Taille de l'oiseau : " + dimensionOiseau);
    Oiseau.scaleModel((0.8*height)/dimensionOiseau.y);
    // ou bien, mise a l'echelle manuelle : Oiseau.scaleModel(0.1);
    // dimensionOiseau = Oiseau.getModSize();
    // println("Taille reduite : " + dimensionOiseau);

    // Selection de l'animation (par exemple, la derniere !)
    Oiseau.setState(animation.length-1); // Une seule pour cet exemple = 0

    // Calcul (eventuel) d'une vitesse d'evolution dans les animations
    pourcentAnimation = constrain(4/(frameRate + 0.01), 0.01, 1);
    
    // Initialisation des variables globales
  }
}

// Fonction de re-tracage de la fenetre
void draw() {

  lights(); // Lumiere pour un meilleur rendu
  
  // Positionnement et orientation de l'objet dans la scene
  translate(width/2,height/2); // Posionnement au centre

  // Trace de l'objet en faisant evoluer son animation
  Oiseau.update(pourcentAnimation);
  Oiseau.render();
  
  // Affiche la position courante dans l'animation
  // println("Frame "+frameCount+" Indice = "+Oiseau.getPosition());
}
