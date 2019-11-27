class City { 
  int postalcode; 
  String name; 
  int x; 
  int y; 
  float population; 
  float density; 
  float surface;
  float altitude;
  
  City(int postalcode, String name, int x, int y, float population, float density, float surface, float altitude) {
    this.postalcode = postalcode;
    this.name = name;
    this.x = x;
    this.y = y;
    this.population = population;
    this.density = density;
    this.surface = surface;
    this.altitude = altitude;
  }

  // put a drawing function in here and call from main drawing loop }
  void drawPoint() {
    stroke(color(0));
    point(this.x, this.y);
  }
  
  // Dessine la ville sur la carte par un cercle où la surface = la taille du cercle et
  // où la density est une variation de couleur bleue
  // --> + la ville est dense en population, + la couleur sera opaque
  // --> + la ville est grande, plus le cercle sera grand
  void drawSurfaceDensity() {
    if(this.surface == 0){
      return;
    }
    
    noStroke();
    
    // Canal alpha proportionnel à la densité de population
    float alpha = map(this.density, minDensity, maxDensity, 200, 100);
    color c = color(255, 127, 80, alpha);
    fill(c);
    
    
    // taille du rayon du cercle en lien avec la surface de la ville
      float extent = map(this.surface, minSurface, maxSurface, 1, 100);
      
    
    circle(this.x, this.y, extent);
    
  }
  
    // Dessine la ville sur la carte par un cercle où la surface = la taille du cercle et
  // où la population est une variation de couleur orange
  // --> + la ville est peuplée en population, + la couleur sera opaque
  // --> + la ville est grande, plus le cercle sera grand
  void drawSurfacePopulation() {
    if(this.surface == 0){
      return;
    }
    
    noStroke();
    
    // Canal alpha proportionnel à la densité de population
    float alpha = map(this.population, minPopulation, maxPopulation, 100, 200);
    color c = color(255, 127, 80, alpha);
    fill(c);
    
    
    // taille du rayon du cercle en lien avec la surface de la ville
      float extent = map(this.surface, minSurface, maxSurface, 1, 100);
      
    
    circle(this.x, this.y, extent);
    
  }
  
      // Dessine la ville sur la carte par un cercle où la surface = la taille du cercle et
  // où l'altitude est une variation de couleur bleue
  // --> + la ville est haute, + la couleur sera opaque
  // --> + la ville est grande, plus le cercle sera grand
  void drawSurfaceAltitude() {
    if(this.surface == 0){
      return;
    }
    
    noStroke();
    
    // Canal alpha proportionnel à la densité de population
    float alpha = map(this.altitude, minAltitude, maxAltitude, 100, 200);
    color c = color(255, 127, 80, alpha);
    fill(c);
    
    
    // taille du rayon du cercle en lien avec la surface de la ville
      float extent = map(this.surface, minSurface, maxSurface, 1, 100);
      
    
    circle(this.x, this.y, extent);
    
  }
  
  // Dessine la ville sur la carte par un cercle où la surface = la taille du cercle et
  // où la population est une teinte de couleur allant du vert (faible) au rouge (fort)
  // --> + la ville est haute, + la couleur sera opaque
  // --> + la ville est grande, plus le cercle sera grand
  void drawSurfacePopulationColor() {
    if(this.surface == 0){
      return;
    }
    
    noStroke();
    
    // Canal alpha proportionnel à la population
    float green = map(this.population, minPopulation, maxPopulation, 255, 0); // plus c'est faible, plus c'est vert
    float red = map(this.population, minPopulation, maxPopulation, 0, 255); // plus c'est faible, moins c'est rouge
    color c = color(red, green, 0, 100);
    fill(c);
    
    
    // taille du rayon du cercle en lien avec la surface de la ville
      float extent = map(this.surface, minSurface, maxSurface, 1, 30);
      
    
    circle(this.x, this.y, extent);
  }
  
  // Plus ville est dense, plus carré sera grand
  // Variation de couleur du bleu
  void drawDensityAltitude() {
    noStroke();
    
    
  }
  
  // Dessine la ville avec les caractérisations de l'INSEE suivant l'appellation (village, ville, etc)
  // Variation de teinte = population
  // Taille = surface
  // Forme = classe (ville/village/...)
  void drawSurfacePopulationUrbanisation() {
    // Choix de la shape
    PShape sh;
    if(this.population < 10) {
      
    }
    else if (this.population < 2000) {
    }
    else if (this.population < 5000) {
    }
    else if (this.population < 20000){
    }
    
    else if(this.population < 50000) {
    }
    else if(this.population < 200000) {
    }
    else {
    }
  }
}
