import java.util.*;

class City implements Comparable { 
  int postalcode; 
  String name; 
  int x; 
  int y; 
  float population; 
  float density; 
  float surface;
  float altitude;
  SVGShape svg;
  
  City(int postalcode, String name, int x, int y, float population, float density, float surface, float altitude) {
    this.postalcode = postalcode;
    this.name = name;
    this.x = x;
    this.y = y;
    this.population = population;
    this.density = density;
    this.surface = surface;
    this.altitude = altitude;
    
    //float extent = map(this.surface, minSurface, maxSurface, 3, 25);
    float extent = map(this.population, minPopulation, maxPopulation, 3, 50);
    colorMode(HSB, 360, 100, 100);
    float hue = map(this.altitude, minAltitude, maxAltitude, 1, 255);
    //float hue = map(this.population, minPopulation, maxPopulation, 1, 100);
    //float hue = map(this.surface, minSurface, maxSurface, 1, 100);
    color c = color(hue,100,100);
    
    // Choix de la shape
    if(this.population < 10) {
      this.svg = new SVGShape(this.x, this.y, extent, c, skull);
    }
    else if (this.population < 20000){
      this.svg = new SVGShape(this.x, this.y, extent, c, triangle);
    }
    
    else if(this.population < 50000) {
      this.svg = new SVGShape(this.x, this.y, extent, c, losange);
    }
    else if(this.population < 200000) {
      this.svg = new SVGShape(this.x, this.y, extent, c, hexagone);
    }
    else {
      this.svg = new SVGShape(this.x, this.y, extent, c, star);
    }
  }
  
  int compareTo(Object o) {
    City other = (City) o;
    return int(this.population - other.population);
  }  
  
  // Dessine la ville avec les caractérisations de l'INSEE suivant l'appellation (village, ville, etc)
  // Variation de teinte = population
  // Taille = surface
  // Forme = classe (ville/village/...)
  void draw() {
    
    // SI [c'est un type carré ou cercle (village ou bourg)]
    if(this.population >= 10 && this.population < 5000 ) {
      strokeWeight(1);
      stroke(0);
      // taille du rayon du cercle en lien avec la surface de la ville
      //float extent = map(this.surface, minSurface, maxSurface, 3, 25);
      float extent = map(this.population, minPopulation, maxPopulation, 3, 50);
      colorMode(HSB, 360, 100, 100);
      float hue = map(this.altitude, minAltitude, maxAltitude, 1, 255);
      //float hue = map(this.population, minPopulation, maxPopulation, 1, 100);
      //float hue = map(this.surface, minSurface, maxSurface, 1, 100);
      color c = color(hue,100,100);
      fill(c);
      
      // C'est un village --> cercle
      if(this.population < 2000) {
        circle(this.x, this.y, extent);
      }
      // C'est un bourg --> carré
      else {
        square(this.x, this.y, extent);
      }
    }
    else {
      this.svg.draw();
    }
  }
  
  void drawWithoutShape() {
      strokeWeight(1);
      stroke(0);
      // taille du rayon du cercle en lien avec la surface de la ville
      //float extent = map(this.surface, minSurface, maxSurface, 3, 25);
      float extent = map(this.population, minPopulation, maxPopulation, 5, 30);
      colorMode(HSB, 360, 100, 100);
      float hue = map(this.altitude, minAltitude, maxAltitude, 1, 255);
      //float hue = map(this.population, minPopulation, maxPopulation, 1, 100);
      //float hue = map(this.surface, minSurface, maxSurface, 1, 100);
      color c = color(hue,100,100);
      fill(c);
      
      // C'est un village --> cercle
      circle(this.x, this.y, extent);
  } 
}
