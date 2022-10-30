
// Importation des librairies
import processing.video.*; // Bibliotheque de controle camera

Capture webCam;      // Declaration de la Capture par Camera
String[] cameras;    // Liste textuelle des webCams disponibles
int mode;
PImage contour ;
PImage monochrome;
PImage seuille;
PImage polie;

// Fonction d'initialisation de l'application - executee une seule fois
void setup() {
  size(640, 480);
  // Recherche des webCams disponibles, par interrogation du systeme d'exploitation
  cameras = Capture.list(); 

  if (0 == cameras.length) {
    println("Pas de Webcam sur cet ordinateur !");
    exit();
  } else {
    // Affichage console de la liste des webcams disponibles
    printArray(cameras); 

    // Initialisation de la webcam Video 
    webCam = new Capture(this, 640, 480); // Webcam; valeurs par defaut

    webCam.start(); // Mise en marche de la webCam
    

  }
      colorMode(RGB, 255,255,255);
 contour = createImage(640,480,RGB);
 monochrome = createImage(640,480,RGB);
 seuille = createImage(640,480,RGB);
 polie = createImage(640,480,RGB);
} // Fin de Setup


// Fonction de re-tracage de la fenetre - executee en boucle
void draw() {
  if (webCam.available() == true) { // Verification de presence d'une nouvelle frame
    // Lecture du flux sur la camera... lecture d'une frame
         background(0);  
         webCam.read();

        
      
        
        if(mode == 0)
        {
            
          image(webCam, 0, 0); // Restitution de l'image captee par la webCam
        }
        else if (mode == 1)
        {
            polir(webCam,monochrome);
            image(monochrome,0,0);
        }

        else if (mode == 2)
        {
           
          noir_et_blanc(webCam,monochrome);
           contour_image(monochrome,contour);
             image(contour,0,0);
        }
        else
        {
           polir(webCam,monochrome);
          
           
           contour_image(monochrome,contour);
           
           seuillage(contour,seuille,235);
           image(seuille,0,0);
        }

  }

}

void keyPressed() {
  println(frameRate);
  if(keyCode == ' ')
  {
    mode = (mode +1)%4;
  }
}

void exit() {
  println("ATTENTION : Le programme s'arrete, donc cloture WebCam !!");
  webCam.stop(); // Arret "propre" de la webcam
  super.exit();
}
