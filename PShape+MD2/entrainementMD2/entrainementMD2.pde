import MD2Importer.*;

MD2_Loader chargeur;
MD2_Model Oiseau;
MD2_ModelState[] animation;
float pourcentageAnimation = 0.2f;

void setup()
{
    size(640,480, P3D);
    chargeur = new MD2_Loader(this);
    Oiseau = chargeur.loadModel("Oiseau.md2","Oiseau.jpg");
    
    if(Oiseau != null)
    {
     chargeur = null;
     animation = Oiseau.getModelStates();
     Oiseau.centreModel();
     Oiseau.setState(animation.length-1);
     Vector3 dimensionOiseau = new Vector3();
     dimensionOiseau = Oiseau.getModSize();
     Oiseau.scaleModel((0.8*height)/dimensionOiseau.y);
    }
    
}

void draw()
{
  background(0);
   translate(width/2,height/2); 
  Oiseau.update(0.1f);
  Oiseau.render(); 
}
