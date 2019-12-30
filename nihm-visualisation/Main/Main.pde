//globally
import java.util.*;

//declare the min and max variables that you need in parseInfo
float minX, maxX;
float minY, maxY;
int totalCount; // total number of places
int minPopulation, maxPopulation;
int minSurface, maxSurface;
int minAltitude, maxAltitude;
float minDensity, maxDensity;

//declare the variables corresponding to the column ids for x and y
int x = 1;
int y = 2;

// déclarer les indices des colonnes utilisées dans le fichier TSV des villes
int IND_POSTAL = 0;
int IND_X = 1;
int IND_Y = 2;
int IND_ISEECODE = 3;
int IND_PLACE = 4;
int IND_POPULATION = 5;
int IND_SURFACE = 6;
int IND_ALTITUDE = 7;

// and the tables in which the city coordinates will be stored
float xList[];
float yList[];
City[] cities;
City firstQuartile; // Ville qui est le premier

// Les formes pour la classification
PShape star, skull, hexagone, losange, triangle;

// Déclaration des widgets
MainMap mainMap;
Scrollbar popMinScroll;
Scrollbar popMaxScroll;
Scrollbar altMinScroll;
Scrollbar altMaxScroll;
FilterShapes filters;

void setup() {
  size(1500, 950);

  // Charger les images SVG pour les formes
  star = loadSVG("star.svg");
  skull = loadSVG("skull.svg");
  hexagone = loadSVG("hexagone.svg");
  losange = loadSVG("losange.svg");
  triangle = loadSVG("triangle.svg");

  // Charger les données TSV 
  readData();

  // Créer les widgets
  mainMap = new MainMap(new PVector(0, 0), new PVector(800, 800), cities);
  popMinScroll = new Scrollbar(new PVector(805, 100), new PVector(1450, 150), minPopulation, maxPopulation, false);
  popMaxScroll = new Scrollbar(new PVector(805, 200), new PVector(1450, 250), minPopulation, maxPopulation, true);
  altMinScroll = new Scrollbar(new PVector(805, 350), new PVector(1450, 400), minAltitude, maxAltitude, false);
  altMaxScroll = new Scrollbar(new PVector(805, 450), new PVector(1450, 500), minAltitude, maxAltitude, true);
  filters = new FilterShapes(new PVector(805, 550), new PVector(1200, 780));
}

void draw() {
  colorMode(RGB, 255);
  background(255);

  // Dessin de l'intérieur des widgets
  mainMap.draw();
  popMinScroll.draw();
  popMaxScroll.draw();
  altMinScroll.draw();
  altMaxScroll.draw();
  filters.draw();

  // Dessin des frontières des widgets
  noFill();
  colorMode(RGB);
  stroke(0);
  strokeWeight(1);
  mainMap.drawBorders();
  popMinScroll.drawBorders();
  popMaxScroll.drawBorders();
  altMinScroll.drawBorders();
  altMaxScroll.drawBorders();
  filters.drawBorders();
  
  // Dessin des textes
  // dessin du texte pour informer du zoom
  fill(0);
  textSize(15);
  text("Zoom : " + int(mainMap.zoom) + " %", 5, 820);
  
  textSize(12);
  text("Affichage des formes à partir de 300%", 5, 835);
  text("Zoom disponible avec scroll et pan navigation disponible", 5, 850);
  
  textSize(15);
  text("Seuil MIN de population : " + int(popMinScroll.currentValue), 805, 90);
  text("Seuil MAX de population : " + int(popMaxScroll.currentValue), 805, 190);
  text("Seuil MIN d'altitude : " + int(altMinScroll.currentValue), 805, 340);
  text("Seuil MAX d'altitude : " + int(altMaxScroll.currentValue), 805, 440);
  
  textSize(25);
  text("Carte des villes de France selon leur nombre d'habitants (en taille) et leur altitude (variation de teinte)", 100, 920);
  strokeWeight(3);
  line(100,925, 1330,925);
}




// ########################################################################
// Callbacks
// ########################################################################
void mouseWheel(MouseEvent event) {
  mainMap.mouseWheel(event);
}

void mouseClicked() {
  mainMap.mouseClicked();
  filters.mouseClicked();
}

void mousePressed() {
  mainMap.mousePressed();
  popMinScroll.mousePressed();
  popMaxScroll.mousePressed();
  altMinScroll.mousePressed();
  altMaxScroll.mousePressed();
}

void mouseReleased() {
  mainMap.mouseReleased();
  popMinScroll.mouseReleased();
  popMaxScroll.mouseReleased();
  altMinScroll.mouseReleased();
  altMaxScroll.mouseReleased();
}

void mouseDragged() {
  mainMap.mouseDragged(); 
  popMinScroll.mouseDragged();
  popMaxScroll.mouseDragged();
  altMinScroll.mouseDragged();
  altMaxScroll.mouseDragged();
}




// ########################################################################
// Lecture des données
// ########################################################################
void readData() {
  String[] lines = loadStrings("../villes.tsv");
  parseInfo(lines[0]); // read the header line

  // tableau des villes
  cities = new City[totalCount - 2];

  for (int i = 2; i < totalCount; ++i) {
    String[] cols = split(lines[i], TAB);

    cities[i-2] = new City(
      int(cols[IND_POSTAL]), 
      cols[IND_PLACE], 
      float(cols[IND_X]), 
      float(cols[IND_Y]), 
      float(cols[IND_POPULATION]), 
      float(cols[IND_POPULATION]) / float(cols[IND_SURFACE]), // density à calculer
      float(cols[IND_SURFACE]), 
      float(cols[IND_ALTITUDE])
      );
  }

  // Trouver les densités max et min parmis les villes du fichier
  findMinMaxDensities();

  // Trier par population (voir le compareTo de la class "City")
  Arrays.sort(cities);
}

void parseInfo(String line) {
  String infoString = line.substring(2); // remove the #
  String[] infoPieces = split(infoString, ',');
  totalCount = int(infoPieces[0]);
  minX = float(infoPieces[1]);
  maxX = float(infoPieces[2]);
  minY = float(infoPieces[3]);
  maxY = float(infoPieces[4]);
  minPopulation = int(infoPieces[5]);
  maxPopulation = int(infoPieces[6]);
  minSurface = int(infoPieces[7]);
  maxSurface = int(infoPieces[8]);
  minAltitude = int(infoPieces[9]);
  maxAltitude = int(infoPieces[10]);
}

void findMinMaxDensities() {
  maxDensity = 0;
  minDensity = 1000000;
  for (int i = 0; i < totalCount-2; i++) {
    City city = cities[i];

    if (city.surface == 0) {
      continue;
    }

    if (maxDensity < city.density) {
      maxDensity = city.density;
    }

    if (minDensity > city.density) {
      minDensity = city.density;
    }
  }
}



// ########################################################################
// Fonctions utilitaires générales
// ########################################################################
float mapX(float x, float newMin, float newMax) {
  return map(x, minX, maxX, newMin, newMax);
}

float mapY(float y, float newMin, float newMax) {
  return map(y, minY, maxY, newMax, newMin);
}

PShape loadSVG(String file) {
  PShape svg = loadShape(file);
  svg.disableStyle();
  return svg;
}
