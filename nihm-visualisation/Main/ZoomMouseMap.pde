// Classe qui a pour rôle de montrer un zoom de la partie de la 
class ZoomMouseMap extends RectWidget {

  // mainMap liée à la Zoom mouse map courante
  private MainMap mainMap;

  // tableau des villes lues via TSV
  private City[] cities;

  public ZoomMouseMap(PVector topLeft, PVector bottomRight, MainMap mainMap, City[] cities) {
    super(topLeft, bottomRight);
    this.mainMap = mainMap;
    this.cities = cities;
  }

  public void draw() {
    PVector focus = this.calculateFocusInMainMap();
    
    // Calcul de la translation entre le point de focus dans la mainMap et le centre de la zoom map courante
    PVector translation = new PVector(this.center.x - this.mainMap.center.x, this.center.y - this.mainMap.center.y);
    
    // Dessin des villes
    this.drawCities(focus, translation);
    
    //print("\n\n");
  }

  // Calcul le point de focus dans la MainMap 
  private PVector calculateFocusInMainMap() {
    if (this.mainMap.isOver()) {
      return new PVector(mouseX, mouseY);
    } else {
      return this.mainMap.panCenter.copy();
    }
  }

  // Dessine les villes avec un zoom de 700% sur le point de focus de la main map
  private void drawCities(PVector focus, PVector translation) {
    for (int i = 0; i < totalCount-2; i++) {
      // Calcul des coordonnées de la ville dans la zoom map
      int coordX = this.getXOfCity(this.cities[i], translation, focus);
      int coordY = this.getYOfCity(this.cities[i], translation, focus);
      
       // SI [les coordonnées ne sont pas comprises dans le widget (trop loin à cause du zoom)]
      boolean isCityNotVisible = coordX < this.topLeft.x || coordX > this.bottomRight.x || coordY < this.topLeft.y || coordY > this.bottomRight.y;
      if(isCityNotVisible) {
        // ALORS [on ne trace pas la ville et on passe à la suivante]
        continue;
      }
      
      //print("coordX : ", coordX, "    coordY", coordY, "\n");
      
      this.cities[i].drawWithShape(coordX, coordY);
    }
  }

  // Calcul la coordonnée en X de la ville en paramètre sur mainMap avec un zoom de 700% et effectue la translation vers la zoomMap  
  private int getXOfCity(City city, PVector translation, PVector focus) {
    float xMin = (focus.x + translation.x) - (7 * this.mainMap.rectWidth / 2);
    float xMax = (focus.x + translation.x) + (7 * this.mainMap.rectWidth / 2);

    // Mapping de la ville et translation vers la zoomMap
    return int(mapX(city.x, xMin, xMax));
  }

  // Calcul la coordonnée en X de la ville en paramètre sur mainMap avec un zoom de 700% et effectue la translation vers la zoomMap
  private int getYOfCity(City city, PVector translation, PVector focus) {
    float yMin = (focus.y + translation.y) - (7 * this.mainMap.rectHeight / 2);
    float yMax = (focus.y + translation.y) + (7 * this.mainMap.rectHeight / 2);
    return int(mapY(city.y, yMin, yMax));
  }
}
