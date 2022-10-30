import processing.video.*;

int ancientPosX = 0;
int ancientPosY = 0;
int appelAncien = 0;

final int wWidth = 800;
final int wHeight = 600;
PImage Image;
String[] cameras;
Capture webCam;

void setup()
{
  colorMode(HSB,360,100,100); 
  size(800,600,P2D);
  surface.setTitle("TP3_WEBCAM");
  cameras = Capture.list(); 
  if(0 == cameras.length)
  {
    println("PAS DE WEBCAM TROUVEE");
    exit();
  }
  webCam = new Capture(this,wWidth,wHeight,cameras[0],30);
  webCam.start();
  smooth();
  Image = loadImage("Image.png");
  Image.resize(600,300);
}

void draw()
{
  
  int posX = 0;
  int posY = 0;
  if(webCam.available())
  {
    webCam.read();
    webCam.loadPixels();
    
    float teinte = 0;
    float satur = 0;
    float bright = 0;
    float decalage = abs((260-teinte) *25+ (30-satur) + (50-bright))*10000;
    for(int y = 10;y < webCam.height-10;y++)
    {
      for(int x = 10; x < webCam.width-10;x++)
      {
        int i = y*webCam.width+x;
        float decalageTempo = 0;
        for (int a = -2; a <= 2;a++)
          {
            for(int b = -2; b <= 2;b++)
            {
              teinte = hue(webCam.pixels[i+a*width+b]) ;
              satur = saturation(webCam.pixels[i+a*width+b]);
              bright = brightness(webCam.pixels[i+a*width+b]);
              decalageTempo += abs((120-teinte) * 25 + (35-satur) + (50-bright));
            }
          }
        
       
       if(decalageTempo < decalage)
        {
        decalage = decalageTempo;
        posX = x;
        posY = y;
        }
      }
      
    }
    webCam.updatePixels();

    image(webCam,0,0);
    image(Image,lerp(ancientPosX,posX-300,.04),lerp(ancientPosY,posY-150,.0));
    appelAncien++;
    if(appelAncien == 8)
    {
    ancientPosX = posX-300;
    ancientPosY = posY-150;
    appelAncien = 0;
    }
  }

}

void exit() {
  println("FIN : ARRET WEBCAM");
  webCam.stop();
  super.exit();
}
