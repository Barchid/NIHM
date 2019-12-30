
// Représente la map principale (la plus grande)
class MainMap extends RectWidget {  
  // Coordonnées du centre pour la navigation PAN
  PVector panCenter;

  // Ancienne coordonnées de la souris (utilisées pour la pan navigation)
  private int oldMouseX = -405049320; // (initialisé à -405049320 pour les problèmes d'initialisation)
  private int oldMouseY = -405049320;

  private City[] cities;

  // référence vers la ville où le curseur se trouve juste en dessous 
  City focusedCity = null;

  // référence vers la ville qui a été cliquée par l'utilisateur
  City clickedCity = null;

  // Valeur de zoom (en %) sur la MAP
  float zoom = 100;

  public MainMap(PVector topLeft, PVector bottomRight, City[] cities) {
    super(topLeft, bottomRight);
    this.panCenter = this.center.copy();
    this.cities = cities;
  }

  @Override
    public void draw() {
    int cityHoveredIndex = -1;

    // Pas les deux dernières parce qu'elles n'existent pas
    for (int i = 0; i < totalCount-2; i++) {
      // Calcul des coordonnées selon la navigation pan et la taille de la carte etc)
      int coordX = this.getXOfCity(this.cities[i]);
      int coordY = this.getYOfCity(this.cities[i]);

      // SI [les coordonnées ne sont pas comprises dans le widget (trop loin à cause du zoom)]
      boolean isCityNotVisible = coordX < this.topLeft.x || coordX > this.bottomRight.x || coordY < this.topLeft.y || coordY > this.bottomRight.y;
      if (isCityNotVisible) {
        // ALORS [on ne trace pas la ville et on passe à la suivante]
        continue;
      }

      // Filtre des populations suivant l'histogramme
      boolean isPopulationFiltered = this.cities[i].population >= popMinScroll.currentValue && this.cities[i].population <= popMaxScroll.currentValue;
      if (!isPopulationFiltered) {
        continue;
      }

      boolean isAltitudeFiltered = this.cities[i].altitude >= altMinScroll.currentValue && this.cities[i].altitude <= altMaxScroll.currentValue;
      if (!isAltitudeFiltered) {
        continue;
      }

      // Dessin de la ville

      // SI [j'ai beaucoup zoomé] (genre 300% ou +)
      if (this.zoom >= 300) {
        // ALORS je peux afficher les formes
        this.cities[i].drawWithShape(coordX, coordY);
      }
      // SINON je n'affiche pas les formes parce que ce serait trop dur de les voir
      else {
        this.cities[i].drawWithoutShape(coordX, coordY);
      }

      if (this.cities[i].isOver(coordX, coordY)) {
        cityHoveredIndex = i;
      }
    }
    this.focusedCity = cityHoveredIndex == -1 ? null : this.cities[cityHoveredIndex];
  }

  // Calcul la coordonnée en X de la ville pour le zoom et le panCenter courant
  private int getXOfCity(City city) {
    float xMin = this.panCenter.x - ((this.zoom/100) * this.rectWidth / 2);
    float xMax = this.panCenter.x + ((this.zoom/100) * this.rectWidth / 2);

    return int(mapX(city.x, xMin, xMax));
  }

  // Calcul la coordonnée en X de la ville pour le zoom et le panCenter courant
  private int getYOfCity(City city) {
    float yMin = this.panCenter.y - ((this.zoom/100) * this.rectHeight / 2);
    float yMax = this.panCenter.y + ((this.zoom/100) * this.rectHeight / 2);

    return int(mapY(city.y, yMin, yMax));
  }

  // gestion du zoom lors d'un scroll
  @Override 
    protected void onMouseWheel(MouseEvent event) {
    float e = event.getCount();

    if (e < 0 && this.zoom < 1000 || e > 0 && this.zoom > 50) {
      this.zoom -= int(e) * 10;
    }

    // SI [je n'ai pas de zoom (ou juste un dézoom)]
    if (this.zoom <= 100) {
      // ALORS [ma navigation pan est recentrée]
      this.panCenter = this.center.copy();
    }
  }

  // Gestion de la pan navigation quand on drag l'objet
  @Override
    protected void onDragged() {
    // Annuler la pan navigation si on ne zoom pas ou qu'il n'y avait pas de oldMouse coordinates
    if (this.zoom <= 100 || this.oldMouseX == -405049320 || this.oldMouseY == -405049320) {
      // Le prochain "onDragged()" fonctionnera ici
      this.oldMouseX = mouseX;
      this.oldMouseY = mouseY;
      return;
    }

    int offsetX = mouseX - this.oldMouseX;
    int offsetY = mouseY - this.oldMouseY;

    float newX = this.panCenter.x + (offsetX);
    float newY = this.panCenter.y + (offsetY);

    // ON assigne le nouveau panCenter
    this.panCenter.x = int(newX);
    this.panCenter.y = int(newY);

    // réassignation des oldMouse pour le prochain drag
    this.oldMouseX = mouseX;
    this.oldMouseY = mouseY;
  }

  @Override
    public void mouseReleased() {
    super.mouseReleased();

    // Remettre les oldMouse à -405049320 pour lancer le prochain drag
    this.oldMouseX = -405049320;
    this.oldMouseY = -405049320;
  }

  @Override
    public void onMouseClicked() {
    if (this.focusedCity != null) {
      this.clickedCity = this.focusedCity;
    } else {
      this.clickedCity = null;
    }
  }
}
