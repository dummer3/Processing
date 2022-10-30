color apply_kernel(int x, int y, float[][] kernel, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int kernel_size = kernel.length;
  int m = kernel_size / 2;
  // Parcours du masque
  for (int i = 0; i < kernel_size; i++){
    for (int j= 0; j < kernel_size; j++){
      int xloc = x+i-m;
      int yloc = y+j-m;
      int loc = xloc + img.width*yloc;
      // Contraint la valeur
      loc = constrain(loc,0,img.pixels.length-1);
      // Calcul de la multiplication avec le masque sur chaque canal
      rtotal += (red(img.pixels[loc]) * kernel[i][j]);
      gtotal += (green(img.pixels[loc]) * kernel[i][j]);
      btotal += (blue(img.pixels[loc]) * kernel[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Renvoie la couleur résultante
  return color(rtotal, gtotal, btotal);
}

//**********************************************************************
// Convolution d'une image par un masque (kernel)
void image_convolution(PImage img, float[][] kernel, PImage resultat)
{
  int kernel_size = kernel.length;
  int m = kernel_size / 2;
 
  for (int y = 0; y < img.height; y++) { // Skip top and bottom edges
    for (int x = 0; x < img.width; x++) { // Skip left and right edges
      if (y>=m && y<img.height-m && x>=m && x<img.width-m){
        color col = apply_kernel(x,y, kernel, img);
        // Return the resulting color
        resultat.pixels[x + img.width*y]=col;
      }
      else{
        resultat.pixels[x + img.width*y]=img.pixels[x + img.width*y];
      }
    }
  }
}
