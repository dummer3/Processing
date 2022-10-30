PImage image_fond;
int rotation = 0;
int posX,posY;
int mouvX,mouvY; 
void setup(){
 colorMode(RGB,255,255,255);
 size(640,480); 
 image_fond = loadImage("./data/hof.jpg");
 image_fond.resize(640,480);  
 image(image_fond,0,0);
 fill(color(255,255,0,50));
 stroke(color(255,0,0));
 posX  = width/2-75;
 posY = height/2-50;
 mouvX = mouvY = 0;
}

void draw()
{
 image(image_fond,0,0);
 translate(posX+mouvX,posY+mouvY);
 translate(75,50);
 rotate(PI/rotation);
 translate(-75,-50);
 rect(0,0,150,100);
 
}
