class ZoomMouseMap {
  float x;
  float y;
  float extent;
  
  ZoomMouseMap(float x, float y, float extent) {
    this.x = x;
    this.y = y; 
    this.extent = extent;
  }
  
  void draw() {
    noFill();
    stroke(0);
    strokeWeight(2);
    square(this.x, this.y, this.extent);
  }
  
  boolean isOver() {
    
  }
}
