// CLasse qui décrit une image SVG à afficher
class SVGShape {

  // The PShape object
  PShape s;
  
  // taille
  float extent;
  
  // Couleur
  color col;

  SVGShape(float extent, color col, PShape s) { 
    this.extent = extent;
    this.col = col;
    
    // Charger le SVG de l'étoile
    this.s = s;
  }
  
  void draw(int x, int y) {
    fill(this.col);
    this.chooseStrokeWeight();
    shapeMode(CENTER);
    shape(s, x, y, extent, extent);
  }
  
  // Choisi la strokeWeight appropriée pour que ce soit visible. on fait ça car, suivant le SVG, ça devient compliqu
  private void chooseStrokeWeight() {
    if(this.s == star) {
      strokeWeight(150);
    }
    else if(this.s == skull) {
      strokeWeight(3);
    }
    else {
     strokeWeight(20); 
    }
  }
}
