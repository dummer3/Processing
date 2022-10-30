void mouseDragged()
{
 if (mouseButton == LEFT)
 {
  mouvX += (mouseX-pmouseX);//*width/100;
  mouvY += (mouseY-pmouseY);//*height/100; 
 }
}
