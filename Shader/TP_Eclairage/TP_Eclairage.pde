PShape box1;
PShape box2;
PShape box3;
PShape box4;

void setup()
{
 size(1200,1000,P3D);
 lights();
 noStroke();

 
 fill(255,255,255);

 ambient(40,255,40);
 box1 = createShape(BOX,width/5);
 ambient(0,0,0);
 

  
 specular(40,40,255); 
 box2 = createShape(BOX,width/5);
 specular(0,0,0); 


 emissive(255,40,40);
 box3 = createShape(BOX,width/5);
 emissive(0,0,0);

ambient(10,85,10);
specular(10,10,85); 
emissive(85,10,10);
box4 = createShape(BOX,width/5);
}

void draw()
{
  background(0);
  
  ambientLight(255,255,255);
  lightSpecular(255,255,255);

  pointLight(255,255,255,mouseX,mouseY,120);
  
  box1.rotateX(0.03);
  box1.rotateY(0.01);
  box2.rotateY(0.02);  
  box3.rotateX(-0.03);
  box3.rotateY(-0.01);
  box4.rotateX(-0.01);
  
  translate(200,200,-100); 
  shape(box1);  
  translate(400,0,0); 
  shape(box2);  
  translate(400,0,0); 
  shape(box3);  
  translate(-400,600,0); 
  shape(box4);  
}
