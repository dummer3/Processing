void mouseClicked()
{
  if(mouseButton == LEFT)
  {
    rotation++;
  }
  else if (mouseButton == RIGHT)
  {
    rotation--;
  }
}

void keyPressed()
{
  switch(keyCode)
  {
    case(37): posX+=width/100; break;
    case(38):  posY+=height/100; break;
    case(39): posX-=width/100; break;
    case(40): posY-=height/100; break;
  }
}
