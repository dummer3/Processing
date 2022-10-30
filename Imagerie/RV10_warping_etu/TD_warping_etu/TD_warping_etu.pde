import java.util.*;

// Images 
PImage source;    // Source image
PImage warpedmarker;
PImage img_lissee;  // image lissée
PImage contours; //image seuillée des contours
PImage gradient;  // image de la norme du gradient
PImage gradnms;  // image du gradient après nms

int seuil_haut = 120;
int seuil_bas = 80;
int thresholdHough=110;
int markerWidth = 302;
int markerHeight = 302;


//**********************************************************
void setup() {
  size(640, 480);
  source = loadImage("../marqueur.jpg"); 
  img_lissee = createImage(source.width, source.height, RGB);
  gradient = createImage(source.width, source.height, RGB);
  contours = createImage(source.width, source.height, RGB);
  gradnms = createImage(source.width, source.height, RGB);  
  //Opencv
  opencv = new OpenCV(this, source);
  warpedmarker = createImage(markerWidth, markerHeight, ARGB);
}


//**********************************************************
void draw() {  
  image(source, 0, 0);

  compute_contours(source, img_lissee, gradient, gradnms, contours); 

  // Transformée de Hough
  int [][] tab = compute_hough(contours, 1, 1);
  //Parcours de l'accumulateur pour récupérer les principales lignes
  Vector<droite> lines = compute_hough_lines(tab, thresholdHough);

  //****************************************
  ////Get the four main lines
  //****************************************
  //A COMPLETER !
  droite[] markerLines = new droite[4];
  int max = 0;
  for (int k = 0; k < 4; k++) {
    //look for best line
    Iterator itr = lines.iterator(); 
    droite my_line= lines.get(0);
    max = 0;

    while (itr.hasNext()) {
      my_line = (droite)itr.next();
      if (my_line.notIn(markerLines, k) && my_line.acc >= max) {
        max = my_line.acc;
        markerLines[k] = my_line;
      }
    }
  }

  //****************************************
  //Compute intersections
  //****************************************
  //ArrayList<PVector> points = new ArrayList<PVector>
  int n = 0;
  PVector[] corners = new PVector[4];
  PVector p;
  for (int k = 0; k < 4; k++) {    
    for (int l = k; l < 4; l++) {
      //compute intersection between line k and line l if relevant
      if (n < 4 && markerLines[k].theta != markerLines[l].theta) {
        p = markerLines[k].intersection(markerLines[l]);
        if(p != null && p.x>0 && p.x<width && p.y > 0 && p.y < height)
          {
            corners[n] = p;
            n++;
          }
      }
    }
  }
  
  for(PVector v : corners)
  {
   ellipse(v.x,v.y,10,10); 
  }

  //*****************************************************************
  // Calcul du warping :
  //*****************************************************************

  PVector[] arranged_corners = new PVector[4]; 
  arranged_corners[0] = corners[2];
  arranged_corners[1] = corners[3];
  arranged_corners[2] = corners[1];
  arranged_corners[3] = corners[0];
  opencv.toPImage(warpPerspective(arranged_corners, markerWidth, markerHeight), warpedmarker);

  //*****************************************************************
  // Affichage
  //*****************************************************************
  // We changed the pixels in destination
  gradient.updatePixels();
  contours.updatePixels();
  if (mousePressed && (mouseButton == RIGHT)) { // Si clic droit de la souris
    // Affiche le marqueur redressé
    image(warpedmarker, 0, 0);
  } else if (mousePressed && (mouseButton == LEFT)) { //Si clic gauche de la souris
    // Affiche les contours, les 4 droites principales et les coins
    image(contours, 0, 0);
    // A COMPLETER
  }
}
