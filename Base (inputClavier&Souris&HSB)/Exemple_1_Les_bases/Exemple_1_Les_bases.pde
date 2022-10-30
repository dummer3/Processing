// Declarations de constantes : Quelques couleurs...
final int rouge = color(255,0,0); 
final int vert  = color(0,255,0); 
final int bleu  = color(0,0,255);
final int noir  = color(0,0,0); 
final int blanc = color(255,255,255); 

// Fonction d'initialisation de l'application - executee une seule fois
void setup(){
  // Initialisation des parametres graphiques utilises
  size(1600,800); // Fenetre de 400*200, sans appeler la carte graphique
  // ou bien : 
  //size(400,200,P2D); // Fenetre de 400*200 avec acceleration carte graphique, en 2D
  surface.setTitle("Exemple 1 - Les Bases - E. Mesnard / ISIMA");
  
  colorMode(RGB, 255,255,255); // fixe format couleur R G B pour fill, stroke, etc...
  fill(vert); // couleur remplissage RGB - noFill() si pas de remplissage
  stroke(rouge); // couleur pourtour RGB - noStroke() si pas de pourtour
  background(noir); // couleur fond fenetre
  
  
  stroke(bleu); // changement de couleur pour trace un cercle bleu...

 for (int i = 0; i < 1600; i = i+5) {
  line(width/2,0, i, height);
  stroke(color(noise(6.0+i,15.0+i)*255f,noise(0.0,0.0+i)*255f,noise(5.0,2.0+i)*255f));
}
}

// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  // Ne rien faire de particulier !
}
