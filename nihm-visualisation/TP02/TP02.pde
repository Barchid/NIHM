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

// Zoom à la souris
int zoom = 100; // au début = 100%

PShape star, skull, hexagone, losange, triangle;

ZoomMouseMap zoomer = new ZoomMouseMap();

void setup() {
  size(1500,900);
  
  // Charger les images SVG
  star = loadSVG("star.svg");
  skull = loadSVG("skull.svg");
  hexagone = loadSVG("hexagone.svg");
  losange = loadSVG("losange.svg");
  triangle = loadSVG("triangle.svg");
  
  readData();
}

PShape loadSVG(String file) {
  PShape svg = loadShape(file);
  svg.disableStyle();
  return svg;
}

void draw(){
  colorMode(RGB, 255);
  background(255);
  colorMode(HSB, 360, 100, 100);
  //in your draw method
  for (int i = 0 ; i < totalCount-2 ; i++) {
    cities[i].drawWithoutShape();
  }
  
  // dessiner le cadre de zoom
  zoomer.draw();
  
  // Tracer des lignes pour délimiter
  stroke(0);
  strokeWeight(2);
  line(0, 805, 805, 805);
  line(805, 0, 805, 805);
  line(805, 200, 1200, 200);
  line(1200, 0, 1200, 200);
  
  // Texte pour indiquer le zoom
  colorMode(RGB);
  fill(0);
  text("Zoom : " + zoom + "%", 10, 850);
}

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
      int(mapX(float(cols[IND_X]))),
      int(mapY(float(cols[IND_Y]))),
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

float mapX(float x) {
 return map(x, minX, maxX, 0, 800);
}

float mapY(float y) {
 return map(y, minY, maxY, 800, 0);
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

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  
  if(e < 0 && zoom < 350 || e > 0 && zoom > 50) {
    zoom -= int(e);
  }
}
