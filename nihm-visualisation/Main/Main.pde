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
ZoomMouseMap zoomMouseMap;
MainMap mainMap;
PopulationSlider populationSlider;
PopulationSlider altitudeSlider;

void setup() {
  size(1500,950);
  
  // Charger les images SVG pour les formes
  star = loadSVG("star.svg");
  skull = loadSVG("skull.svg");
  hexagone = loadSVG("hexagone.svg");
  losange = loadSVG("losange.svg");
  triangle = loadSVG("triangle.svg");
  
  // Charger les données TSV 
  readData();
  
  // Créer les widgets
  mainMap = new MainMap(new PVector(0,0), new PVector(800,800), cities);
  zoomMouseMap = new ZoomMouseMap(new PVector(805, 0), new PVector(1305, 500), mainMap, cities);
  populationSlider = new PopulationSlider(new PVector(805, 0), new PVector(1005, 400), cities);
  altitudeSlider = new PopulationSlider(new PVector(1010, 0), new PVector(1210, 400), cities);
}

void draw(){
  colorMode(RGB, 255);
  background(255);
  
  // Dessin de l'intérieur des widgets
  mainMap.draw();
  populationSlider.draw();
  altitudeSlider.draw();
  
  // Dessin des frontières des widgets
  noFill();
  colorMode(RGB);
  stroke(0);
  strokeWeight(1);
  mainMap.drawBorders();
  populationSlider.drawBorders();
  altitudeSlider.drawBorders();
}




// ########################################################################
// Callbacks
// ########################################################################
void mouseWheel(MouseEvent event) {
  mainMap.mouseWheel(event);
}

void mouseClicked() {
  mainMap.mouseClicked();
}

void mousePressed() {
  mainMap.mousePressed();
}

void mouseReleased(){
 mainMap.mouseReleased(); 
}

void mouseDragged() {
 mainMap.mouseDragged(); 
}




// ########################################################################
// Lecture des données
// ########################################################################
void readData() {
  String[] lines = loadStrings("../villes.tsv");
  parseInfo(lines[0]); // read the header line
  
  // tableau des villes
  cities = new City[totalCount - 2];
  
  for (int i = 2 ; i < totalCount ; ++i) {
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
  for (int i = 0 ; i < totalCount-2 ; i++) {
     City city = cities[i];
     
     if(city.surface == 0){
       continue;
     }
     
     if(maxDensity < city.density) {
       maxDensity = city.density;
     }
     
     if(minDensity > city.density) {
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
