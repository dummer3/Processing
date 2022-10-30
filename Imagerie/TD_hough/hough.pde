// calcul de l'accumulateur sur l'image im de contours binaires
// theta : -90:1:89 -> idx = theta + 90 : 0 -> 180
// r : -r_max:1:r_max 
int [][] compute_hough(PImage im){
  int rmax = (int) sqrt(im.height*im.height+im.width*im.width); 
  float r = 0; int loc = 0;
  int [][] tab = new int[180][2*rmax+1];
  for (int x = 0; x < width; x++) { //Parcours de colonnes
    for (int y = 0; y < height; y++ ) { //parcours des lignes
      // Pixel location
      loc = x + y*im.width;
      if (im.pixels[loc] ==  color(255)) {
        for (int theta = -90; theta < 90; theta++){ //Parcours des theta
          r = x*cos(radians(theta))+y*sin(radians(theta)); //calcul de r
          tab[theta+90][round(r+rmax)] = tab[theta+90][round(r+rmax)] + 1;
        }
      }
    }
  }
  return tab;
}


// Calcul des lignes principales (accumulateur supérieur au seuil)
Vector<droite> compute_hough_lines(int [][] tab, int seuil_hough){
  Vector<droite> lines = new Vector<droite>();
  int rmax = (int)sqrt(height*height+width*width);
  int count = 0;
  for (int theta = 0; theta < 180; theta++) { //Parcours des thetas
    for (int r = 0; r < 2*rmax+1; r++ ) { //parcours des r
      if (tab[theta][r] > seuil_hough){
        droite my_line = new droite();
        my_line.acc = tab[theta][r];
        my_line.theta = theta-90;
        my_line.r = r - rmax;           
        lines.addElement(my_line);
        count++;
      }
    }
  }
  println("nombre de lignes trouvées : ", count);
  return lines;
}
