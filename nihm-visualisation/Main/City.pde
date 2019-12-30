import java.util.*;

class City implements Comparable { 
  int postalcode; 
  String name;

  // Les coordonnées X et Y de base (entre 0 et 1)
  float x; 
  float y; 

  float population; 
  float density; 
  float surface;
  float altitude;

  // Données utilisées pour le dessin
  color c;
  float extent;
  SVGShape svg;
  float alpha; // l'alpha sert à faire en sorte que les petites villes soient plus simples à voir

  City(int postalcode, String name, float x, float y, float population, float density, float surface, float altitude) {
    this.postalcode = postalcode;
    this.name = name;
    this.x = x;
    this.y = y;
    this.population = population;
    this.density = density;
    this.surface = surface;
    this.altitude = altitude;

    //float extent = map(this.surface, minSurface, maxSurface, 3, 25);
    this.extent = map(this.population, minPopulation, maxPopulation, 4, 75);
    this.alpha = map(this.population, minPopulation, maxPopulation, 100, 50); // Calcul du alpha pour pouvoir mieux visualiser les plus petites villes

    colorMode(HSB, 360, 100, 100, 100);
    float hue = map(this.altitude, minAltitude, maxAltitude, 1, 255);
    //float hue = map(this.population, minPopulation, maxPopulation, 1, 100);
    //float hue = map(this.surface, minSurface, maxSurface, 1, 100);
    this.c = color(hue, 100, 100, this.alpha);

    // Choix de la shape
    if (this.population < 10) {
      this.svg = new SVGShape(3*this.extent, this.c, skull);
    } else if (this.population < 20000) {
      this.svg = new SVGShape(2*this.extent, this.c, triangle);
    } else if (this.population < 50000) {
      this.svg = new SVGShape(2*this.extent, this.c, losange);
    } else if (this.population < 200000) {
      this.svg = new SVGShape(2*this.extent, this.c, hexagone);
    } else {
      this.svg = new SVGShape(2*this.extent, this.c, star);
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
  void drawWithShape(int coordX, int coordY) {   
    // SI [c'est un type carré ou cercle (village ou bourg)]
    if (this.population >= 10 && this.population < 5000 ) {
      strokeWeight(1);
      stroke(0);
      if (this == mainMap.clickedCity) {
        colorMode(RGB, 255, 255, 255, 100);
        fill(color(59, 59, 152));
        textSize(20);
        text(this.name, coordX+this.extent, coordY);

        fill(color(59, 59, 152, this.alpha));
      } else if (this == mainMap.focusedCity) {
        colorMode(RGB, 255, 255, 255, 100);
        fill(color(33, 140, 116));
        textSize(20);
        text(this.name, coordX + this.extent, coordY);

        fill(color(33, 140, 116, this.alpha));
      } else {
        colorMode(HSB, 360, 100, 100, 100);
        fill(this.c);
      }

      // C'est un village --> cercle
      if (this.population < 2000) {
        circle(coordX, coordY, 1.5*this.extent);
      }
      // C'est un bourg --> carré
      else {
        square(coordX, coordY, 1.5*this.extent);
      }
    } else {
      if (this == mainMap.clickedCity) {
        colorMode(RGB, 255, 255, 255, 100);
        color cust = color(59, 59, 152);
        this.svg.drawWithColor(coordX, coordY, cust);
        textSize(20);
        text(this.name, coordX+this.extent, coordY);

        fill(color(59, 59, 152, this.alpha));
      } else if (this == mainMap.focusedCity) {
        colorMode(RGB, 255, 255, 255, 100);
        color cust = color(33, 140, 116);
        this.svg.drawWithColor(coordX, coordY, cust);
        textSize(20);
        text(this.name, coordX + this.extent, coordY);

        fill(color(33, 140, 116, this.alpha));
      } else {
        this.svg.draw(coordX, coordY);
      }
    }
  }

  // Dessine la ville mais sans la forme de classification (svg)
  void drawWithoutShape(int coordX, int coordY) {

    strokeWeight(1);
    stroke(0);

    // Choix de la couleur suivant le focus et le clicked
    if (this == mainMap.clickedCity) {
      colorMode(RGB, 255, 255, 255, 100);
      fill(color(59, 59, 152));
      textSize(20);
      text(this.name, coordX+this.extent, coordY);

      fill(color(59, 59, 152, this.alpha));
    } else if (this == mainMap.focusedCity) {
      colorMode(RGB, 255, 255, 255, 100);
      fill(color(33, 140, 116));
      textSize(20);
      text(this.name, coordX + this.extent, coordY);

      fill(color(33, 140, 116, this.alpha));
    } else {
      colorMode(HSB, 360, 100, 100, 100);
      fill(this.c);
    }

    // C'est un village --> cercle
    circle(coordX, coordY, this.extent);
  }

  // Fonction qui renvoie true si le curseur est contenu dans le dessin de la ville pour un zoom donné (comme ça on sait si les formes sont affichées ou pas)
  boolean isOver(int coordX, int coordY) {
    // SI [les formes sont affichées]
    if (mainMap.zoom >= 300) {
      if (this.population >= 10 && this.population < 5000) {
        return dist(coordX, coordY, mouseX, mouseY) <= (1.5*this.extent) / 2 + 1;
      } else {
        return dist(coordX, coordY, mouseX, mouseY) <= this.extent + 1;
      }
    }
    // SINON (on n'affiche que des cercles
    else {
      return dist(coordX, coordY, mouseX, mouseY) <= this.extent/2 + 1;
    }
  }
}
