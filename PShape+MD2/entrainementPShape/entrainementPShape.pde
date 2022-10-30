//import shapes3d.*;

int posX,posY;

PImage texture;
PShape box;
PShape box2;
int type = 0;

void setup()
{
    textureMode(NORMAL);   
  texture = loadImage("hof.jpg");

  size(600,500,P3D);
  background(0);
  box = createShape(BOX,250);
  box.setTexture(texture);
  posX = posY = 0;
    
  box2 = createShape();
  box2.beginShape(QUAD);
  box2.texture(texture);

  box2.noStroke();
  box2.vertex(-1,-1, 1, 0, 0);
  box2.vertex( 1,-1, 1, 1, 0);
  box2.vertex( 1, 1, 1, 1, 1);
  box2.vertex(-1, 1, 1, 0, 1);
  
  // Face -Z = Arriere
  box2.vertex( 1,-1,-1, 0, 0);
  box2.vertex(-1,-1,-1, 1, 0);
  box2.vertex(-1, 1,-1, 1, 1);
  box2.vertex( 1, 1,-1, 0, 1);
  
  // Face +Y = Dessous
  box2.vertex(-1, 1, 1, 0, 0);
  box2.vertex( 1, 1, 1, 1, 0);
  box2.vertex( 1, 1,-1, 1, 1);
  box2.vertex(-1, 1,-1, 0, 1);

  // Face -Y = Dessus
  //box2.vertex(-1,-1,-1, 0, 0);
  //box2.vertex( 1,-1,-1, 1, 0);
  //box2.vertex( 1,-1, 1, 1, 1);
  //box2.vertex(-1,-1, 1, 0, 1);
  
   // Face +X = Droite
  box2.vertex( 1,-1, 1, 0, 0);
  box2.vertex( 1,-1,-1, 1, 0);
  box2.vertex( 1, 1,-1, 1, 1);
  box2.vertex( 1, 1, 1, 0, 1);

  // Face -X = Gauche
  box2.vertex(-1,-1,-1, 0, 0);
  box2.vertex(-1,-1, 1, 1, 0);
  box2.vertex(-1, 1, 1, 1, 1);
  box2.vertex(-1, 1,-1, 0, 1);
  box2.endShape();
  box2.scale(125);
}

void draw()
{
if(type == 0)
{
  mouvement(box);
}
else
{
  mouvement(box2);
}
}

void keyPressed()
{
  if(key == ' ')
  {
   type = (type+1)%2; 
  }
}

void mouvement(PShape b)
{
  posX = (int) lerp(posX,mouseX,0.1);
  posY = (int) lerp(posY,mouseY,0.1);
  background(0);
  translate(posX,posY,0);
  b.rotateX(0.005);
  b.rotateY(0.003);
  shape(b,25,25);
}
