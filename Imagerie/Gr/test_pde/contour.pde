void contour_image(PImage monochrome,PImage contour)
{
   monochrome.loadPixels();
   contour.loadPixels();
  for(int i = 1;i <monochrome.height;i++)
  {
   for(int j = 1;j < monochrome.width;j++)
   {
     contour.pixels[i*monochrome.width+j] = (int)sqrt(pow(-monochrome.pixels[i*monochrome.width+j-1]+monochrome.pixels[i*monochrome.width+j],2)+pow(-monochrome.pixels[(i-1)*monochrome.width+j]+monochrome.pixels[i*monochrome.width+j],2)) ;
   }
  }
  contour.updatePixels();

}

void noir_et_blanc(PImage webCam,PImage resultat)
{

   webCam.loadPixels();
   resultat.loadPixels();
   
  for(int i = 0;i <webCam.height;i++)
  {
   for(int j = 0;j < webCam.width;j++)
   {
     float b = brightness(webCam.pixels[i*webCam.width+j])*2.5;
     resultat.pixels[i*webCam.width+j] = color(1,1,1)*(int)b;
   }
  }
   resultat.updatePixels();


}
void polir(PImage webCam,PImage polie)
{
  float[] masque = {0.1,0.1,0.1,0.1,0.2,0.1,0.1,0.1,0.1};
     webCam.loadPixels();
   polie.loadPixels();
   
  for(int i = 1;i <webCam.height-1;i++)
  {
   for(int j = 1;j < webCam.width-1;j++)
   {
   float sum = 0;
   for (int x = -1;x<2;x++)
   {
        for (int y = -1;y<2;y++)
   {
     sum += brightness(webCam.pixels[(i+y)*contour.width+j+x])*masque[(y+1)*3+x+1];
   }
   }
   polie.pixels[i*contour.width+j] = color(sum);
   }
  }
   polie.updatePixels();
}

void seuillage(PImage contour,PImage zolie,float seuil)
{
     contour.loadPixels();
   zolie.loadPixels();
   for(int i = 1;i <contour.height;i++)
  {
   for(int j = 1;j < contour.width;j++)
   {
     if(constrain(brightness(contour.pixels[i*contour.width+j]),0,255) <= seuil)
     {
       zolie.pixels[i*contour.width+j] = color(0,0,0);
     }
     else
     {
       zolie.pixels[i*contour.width+j] = color(255,255,255);
     }
   }
  }
   zolie.updatePixels();
}
