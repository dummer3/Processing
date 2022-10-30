int posX,posY,taille;


void setup()
{
 size(800,640,P2D);
 surface.setTitle("Exemple Souris");
 colorMode(HSB,360,1,1);
 background(0);
 posX = width/2;
 posY = height/2;
 taille = min(width,height)/10;
 square(posX,posY,taille);
 smooth();
 
}
void draw()
{
}
void keyReleased()
{
    if(keyCode == 37)
    {
      posX--;
    }
    else if(keyCode == 39)
    {
      posX++;
  }
      else if(keyCode == 38)
    {
      posY--;
    }
    else if(keyCode == 40)
    {
      posY++;
    }
    mouvementCarree();
    
}

void mouseDragged()
{
 switch(mouseButton)
 {
   case(LEFT):
   taille ++ ; break;
   case(RIGHT):
   taille-- ; break;
 }
 mouvementCarree();
}
 void mouseMoved()
 {
   posX = pmouseX-taille/2;
   posY = pmouseY-taille/2;
   mouvementCarree();
}

void mouvementCarree()
{
  background(0);
  fill((posX*posY*360)/(width*height),(posX/(float)width),(posY/(float)height));
  square(posX,posY,taille);
}
