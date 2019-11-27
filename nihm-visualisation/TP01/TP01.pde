//globally

//declare the min and max variables that you need in parseInfo
float minX, maxX;
float minY, maxY;
int totalCount; // total number of places
int minPopulation, maxPopulation;
int minSurface, maxSurface;
int minAltitude, maxAltitude;

//declare the variables corresponding to the column ids for x and y
int x = 1;
int y = 2;

// and the tables in which the city coordinates will be stored
float xList[];
float yList[];

void setup() {
  size(800,800);
  readData();
}

void draw(){
  background(255);
  
  //in your draw method
  color black = color(0);
  for (int i = 0 ; i < totalCount ; i++) {
    x = int(mapX(xList[i]));
    y = int(mapY(yList[i]));
    set(x, y, black);
  }
}

void readData() {
  String[] lines = loadStrings("../villes.tsv");
  parseInfo(lines[0]); // read the header line
  
  xList = new float[totalCount];
  yList = new float[totalCount];
  
  for (int i = 2 ; i < totalCount ; ++i) {
    String[] columns = split(lines[i], TAB);
    xList[i-2] = float (columns[1]);
    yList[i-2] = float (columns[2]);
  }
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
