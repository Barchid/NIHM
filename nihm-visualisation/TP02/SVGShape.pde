// CLasse qui décrit une image SVG à afficher
class SVGShape {

  // The PShape object
  PShape s;
  
  // The location where we will draw the shape
  float x, y;
  
  // taille
  float extent;
  
  // Couleur
  color col;

  SVGShape(float x, float y, float extent, color col, PShape s) {
    this.x = x;
    this.y = y; 
    this.extent = extent;
    this.col = col;
    
    // Charger le SVG de l'étoile
    this.s = s;
  }
  
  void draw() {
    fill(this.col);
    strokeWeight(5);
    stroke(0);
    shapeMode(CENTER);
    shape(s, x, y, extent, extent);
  }
}
