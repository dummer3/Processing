

PImage fondecran;
color couleurRect;
int deltaX, deltaY;
void setup(){
  size(640, 480);
  fondecran = loadImage("sun.jpg");
  fondecran.resize(640,480);
  couleurRect = color(247, 241, 27, 100);
  fill(couleurRect);
  stroke(#FF0000);
  strokeWeight(5);
  deltaX = 0;
  deltaY = 0;
  
}

void draw(){
  background(fondecran);
  translate(width/2 + deltaX, deltaY + height/2);
  rect(-150/2, -50, 150, 100);
}


void mouseDragged(){
  if(mouseButton == LEFT){
    deltaX -= pmouseX - mouseX;
    deltaY -= pmouseY - mouseY;
  }
}

void keyPressed(){
  switch(keyCode){
    case LEFT:
      deltaX -= 1;
      break;
    case RIGHT:
      deltaX += 1;
    case UP:
      deltaY -= 1;
      break;
    case DOWN:
      deltaY += 1;
      break;
    default: 
      deltaX += 0;
  }
}
