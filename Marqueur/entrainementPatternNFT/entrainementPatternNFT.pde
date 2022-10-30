import processing.video.*; 
import jp.nyatla.nyar4psg.*;

String[] cameras;  
Capture webCam;
MultiMarker sceneMM; 



MultiNft sceneNFT; 

void setup()
{
  size(640, 480, P3D);
  
  if (cameras.length == 0) {
    exit();
  } else {
    webCam = new Capture(this, 640, 480, cameras[0], 30);
    webCam.start();
  }
  
   sceneMM = new MultiMarker(this, 640, 480, 
    "camera_para.dat", 
    NyAR4PsgConfig.CONFIG_PSG);
    
   sceneMM.addARMarker("Marqueur_ISIMA.patt", 80); 
   
   sceneNFT = new MultiNft(this, widthCapture, heightCapture, 
    "camera_para.dat", 
    NyAR4PsgConfig.CONFIG_PSG);
  sceneNFT.addNftTarget("Image_ISIMA", 80);
}

void draw()
{
   if (webCam.available() == true) { 
       webCam.read(); 

    sceneMM.detect(webCam); 
    webCam.updatePixels(); 
    image(webCam, 0, 0);
    if (sceneMM.isExist(0)) {
      
   }
   
   
    sceneNFT.detect(webCam); 
    if (sceneNFT.isExist(0)) {
       sceneNFT.beginTransform(0);
       sceneNFT.endTransform();
    }
   }
}
