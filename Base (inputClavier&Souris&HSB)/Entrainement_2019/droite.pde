public class droite
{
  int theta,r,poids;
  public droite()
  {
    theta=r=poids=0;
  }
  public droite(droite line)
  {
    this.theta = line.theta;
    this.poids = line.poids;
    this.r = line.r;
  }
  
  void display(int w,int h)
  {
   float x1,x2,y1,y2;
   x1 = 0;
   x2 = w;
   y1 = (r-x1*cos(radians(theta)))/sin(radians(theta));
   y2 = (r-x2*cos(radians(theta)))/sin(radians(theta));
   line(x1,y1,x2,y2);
  }
}
