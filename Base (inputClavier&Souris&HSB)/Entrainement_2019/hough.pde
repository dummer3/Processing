int[][] tab_de_hough(PImage img,float step)
{
  int rMax = int(sqrt(width*width+height*height));
  int thetaMax = int(180/step);
 int [][] tab = new int[thetaMax][rMax]; 
 
 for(int i = 0; i < img.height; i++)
 {
  for(int j =0; j < img.width;j++) 
  {
    int pos = i*img.width+j;
    if(img.pixels[pos] >= color(125))
    {
     for(int m=0;m < thetaMax;m++)
     {
       int r = x*cos(theta)+y*sin(theta);
       tab[m][r] +=1
    }
  }
 }
 return tab;
}

Vector<droite> compute_hough_lines(int [][] tab, int seuil_hough){
  Vector<droite> lines = new Vector<droite>();
  int nt=tab.length; 
  int nr=tab[0].length;  
  int rmax = (int)sqrt(height*height+width*width);
  float stept = 180/float(nt);
  float stepr = 2*rmax/float(nr);
  for (int idt = 0; idt<nt;idt++){ //Parcours des theta
    for (int idr = 0; idr<nr;idr++){
      if (tab[idt][idr] > seuil_hough){
        droite my_line = new droite();
        my_line.acc = tab[idt][idr];
        my_line.theta = -90+idt*stept;
        my_line.r = idr*stepr - rmax;           
        lines.addElement(my_line);
      }
    }
  } //<>//
  return lines;
}
