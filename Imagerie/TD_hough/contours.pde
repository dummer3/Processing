// Calcul du gradient simple (Roberts)
void compute_gradient_simple(PImage img, PImage gradient){
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
void compute_gradient_sobel(PImage img, PImage gradient){
  float[][] filtreSobelH = { { -1, 0, 1 },
                        { -2,  0, 2 },
                        { -1, 0, 1 } }; 
  float[][] filtreSobelV = { { 1, 2, 1 },
                        { 0,  0, 0 },
                        { -1, -2, -1 } }; 
  float grad = 0;
  int loc = 0;
  
  //Parcours des pixels de l'image
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      float gradV = 0, gradH=0; 
      //Parcours du kernel :
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          loc = (y + ky)*img.width + (x + kx);
          float val = brightness(img.pixels[loc]);
          // Calcul
          gradV += filtreSobelV[ky+1][kx+1] * val;
          gradH += filtreSobelH[ky+1][kx+1] * val;          
        }
      }
      grad = sqrt(gradH*gradH+gradV*gradV); 
      loc = x + y*img.width;
               
      gradient.pixels[loc] = color(grad);
    }      
  }
}

//**********************************************************************
// Calcul du gradient et de l'orientation
void compute_gradient_Sobel_or(PImage img, PImage gradient, PImage orientation){
  float[][] filtreSobelH = { { -1, 0, 1 },
                        { -2,  0, 2 },
                        { -1, 0, 1 } }; 
  float[][] filtreSobelV = { { 1, 2, 1 },
                        { 0,  0, 0 },
                        { -1, -2, -1 } }; 
  float grad = 0, theta = 0;
  int loc = 0;
  
  //Parcours des pixels de l'image
  for (int x = 1; x < img.width-1; x++) {
    for (int y = 1; y < img.height-1; y++ ) {
      float gradV = 0, gradH=0; 
      //Parcours du kernel :
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          loc = (y + ky)*img.width + (x + kx);
          float val = brightness(img.pixels[loc]);
          // Calcul
          gradV += filtreSobelV[ky+1][kx+1] * val;
          gradH += filtreSobelH[ky+1][kx+1] * val;          
        }
      }
      grad = sqrt(gradH*gradH+gradV*gradV);       
      if (gradH>5||gradV>5){
        theta = atan2(gradV,gradH);
      }
      else{
        theta = 0;
      }
      
      loc = x + y*img.width;      
      
      orientation.pixels[loc] = color(theta*255./(float)Math.PI);//scaled to 0 255           
      gradient.pixels[loc] = color(grad);
    }      
  }
}

//**********************************************************************
// Seuillage hysteresis
void seuillage(PImage img, PImage imgSeuillee, int s_bas, int s_haut){
  int loc = 0;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Pixel courant
      loc = x + y*img.width;
      color pix = img.pixels[loc];
      imgSeuillee.pixels[loc] = color(0);
      if (brightness(pix) > s_haut){
        imgSeuillee.pixels[loc] = color(255);        
      }
      else if(brightness(pix) > s_bas){
        imgSeuillee.pixels[loc] = color(127);   
      }
    }      
  }   
  // Iterations jusqu'à ne plus avoir de sélection parmi les pixels indécis
  boolean done = false;
  while(done == false){
    done = true;
    for (int x = 1; x < img.width-1; x++) {
      for (int y = 1; y < img.height-1; y++ ) {
        // Pixel location and color
        loc = x + y*imgSeuillee.width;
        color pix = imgSeuillee.pixels[loc];
        if (pix ==  color(127)){//contour possible
          imgSeuillee.pixels[loc] = color(0);
          for (int k = -1; k<2;k++){
            for (int l = -1; l<1+1;l++){
              if (imgSeuillee.pixels[x+k + (y+l)*imgSeuillee.width]==color(255)){
                imgSeuillee.pixels[loc] = color(255);
                done = false;
              }
            }
          }            
        }
      }
    } 
  }
}

//**********************************************************************
// Calcul des contours 
void compute_contours(PImage img, PImage img_lissee,PImage gradient,PImage contours){
  float[][] lissage = { { 1./9.,1./9.,1./9. },
                    { 1./9.,1./9.,1./9. },
                    { 1./9.,1./9.,1/9. } };  
  image_convolution(img, lissage, img_lissee); 
  img_lissee.updatePixels();
  //compute_gradient_simple(img_lissee, gradient);
  compute_gradient_sobel(img_lissee, gradient);
  //compute_gradient_sobel_or(img_lissee, gradient, orientation);
  gradient.updatePixels();
  seuillage(gradient, contours, seuil_bas, seuil_haut); 
  contours.updatePixels();
}
    
