class PopulationSlider extends RectWidget {
  private City[] cities;
  
  public PopulationSlider(PVector topLeft, PVector bottomRight, City[] cities) {
    super(topLeft, bottomRight);
    this.cities = cities;
  }
  
  public void draw() {
    colorMode(RGB, 255);
    noStroke();
    
    this.drawSliderBack();
  }
  
  private void drawSliderBack() {
    fill(color(200, 200, 200));
    rect(this.topLeft.x + 75, this.topLeft.y + 50, this.rectWidth - 150, this.rectHeight - 75);
    stroke(0);
    line(this.topLeft.x + 100, this.topLeft.y + 50, this.topLeft.x + 100, this.bottomRight.y - 25);
  }
  
  private void drawHistogram() {
    
  }
  
  private void drawScroller() {
    
  }
}
