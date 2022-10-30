//**********************************************************************
// Calcul du gradient simple (Roberts)
void compute_gradient_simple(PImage img, PImage gradient) {
  int loc = 0, topLoc = 0, leftLoc = 0;
  float gradH = 0, gradV = 0, grad = 0;
  // Parcours de l'image en ignorant le bord
  for (int x = 1; x < img.width; x++) {
    for (int y = 1; y < img.height; y++ ) {
      // Pixel courant
      loc = x + y*img.width;
      color pix = img.pixels[loc];  
      // Pixel de gauche
      leftLoc = (x-1) + y*img.width;
      color leftPix = img.pixels[leftLoc];
      // Pixel du haut
      topLoc = x + (y-1)*img.width;
      color topPix = img.pixels[topLoc];

      // Calcul du gradient
      gradH = abs(brightness(pix) - brightness(leftPix));
      gradV = abs(brightness(pix) - brightness(topPix));
      grad = sqrt(gradH*gradH+gradV*gradV);
      gradient.pixels[loc] = color(grad);
    }
  }
}

//**********************************************************************
// Calcul du gradient de Sobel
void compute_gradient_sobel(PImage img, PImage gradient) {
  float[][] filtreSobelH = { { -1, 0, 1 }, 
    { -2, 0, 2 }, 
    { -1, 0, 1 } }; 
  float[][] filtreSobelV = { { 1, 2, 1 }, 
    { 0, 0, 0 }, 
    { -1, -2, -1 } }; 
  float grad = 0;
  float gradH = 0;
  float gradV = 0;
  float maxgrad = 0;
  float[] gradmag = new float[img.width*img.height];
  int loc = 0;

  //Parcours des pixels de l'image
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      gradV = 0; gradH = 0;      
      //Calcul du résultat de la convolution par les 2 masques :
      gradH = apply_kernel_lum(x, y, filtreSobelH, img);
      gradV = apply_kernel_lum(x, y, filtreSobelV, img);
      //Calcul de la norme du gradient :
      grad = sqrt(gradH*gradH+gradV*gradV); 
      gradmag[x+y*img.width] = grad;
      if (grad>maxgrad) {
        maxgrad = grad;
      }
      
      //Stockage dans une PImage (valeur entre 0 et 255)
      loc = x + y*img.width;
      //gradient.pixels[loc] = color(grad);
    }
  }
  //Rescale entre 0 et 255
  for (int k = 0; k < gradmag.length; k++)
  {
    gradmag[k] = 255*gradmag[k]/maxgrad; 
    gradient.pixels[k] = color(int(gradmag[k]));
  }
}

//**********************************************************************
// Calcul du gradient et de l'orientation
void compute_gradient_Sobel_or(PImage img, PImage gradient, PImage orientation) {
  float[][] filtreSobelH = { { -1, 0, 1 }, 
    { -2, 0, 2 }, 
    { -1, 0, 1 } }; 
  float[][] filtreSobelV = { { 1, 2, 1 }, 
    { 0, 0, 0 }, 
    { -1, -2, -1 } }; 
  float grad = 0, theta = 0;
  int loc = 0;
  float maxgrad = 0;  
  float[] gradmag = new float[img.width*img.height];
  
  //Parcours des pixels de l'image
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      float gradV = 0, gradH=0; 
      //Calcul du résultat de la convolution par les 2 masques :
      gradH = apply_kernel_lum(x, y, filtreSobelH, img);
      gradV = apply_kernel_lum(x, y, filtreSobelV, img);
      //Calcul de la norme du gradient :
      grad = sqrt(gradH*gradH+gradV*gradV); 
      gradmag[x+y*img.width] = grad;
      if (grad>maxgrad) {
        maxgrad = grad;
      } 
      if (gradH>5||gradV>5) {
        theta = atan2(gradV, gradH);
      } else {
        theta = 0;
      }
      loc = x + y*img.width;      

      orientation.pixels[loc] = color(theta*255./(float)Math.PI);//scaled to 0 255           
      //gradient.pixels[loc] = color(grad, grad, grad);
    }
  }
  
  //Rescale entre 0 et 255
  for (int k = 0; k < gradmag.length; k++)
  {
    gradmag[k] = 255*gradmag[k]/maxgrad; 
    gradient.pixels[k] = color(int(gradmag[k]));
  }
}


//**********************************************************************
// Seuillage simple
void seuillage(PImage img, PImage imgSeuillee, int seuil){
  int loc = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Pixel courant
      loc = x + y*img.width;
      color pix = img.pixels[loc];
      if (brightness(pix) > seuil) {
        imgSeuillee.pixels[loc] = color(255);
      } else {
        imgSeuillee.pixels[loc] = color(0);
      }      
    }
  }
}

//**********************************************************************
// Calcul des contours 
void compute_contours(PImage img, PImage img_lissee, PImage gradient, PImage contours) {
  float[][] lissage = { { 1./9., 1./9., 1./9. }, 
    { 1./9., 1./9., 1./9. }, 
    { 1./9., 1./9., 1/9. } };  
  image_convolution(img, lissage, img_lissee); 
  img_lissee.updatePixels();
  //compute_gradient_simple(img_lissee, gradient);
  compute_gradient_sobel(img_lissee, gradient);
  gradient.updatePixels();
  seuillage(gradient, contours, seuil); 
  contours.updatePixels();
}
