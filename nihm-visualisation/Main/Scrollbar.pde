class Scrollbar extends RectWidget {
  private int minValue;
  private int maxValue;
  private float currentX; // valeur en coord X du slider courant pour la valeur min
  public float currentValue; // valeur du slider courant (en vraie valeur)

  public Scrollbar(PVector topLeft, PVector bottomRight, int minValue, int maxValue, boolean isAtEnd) {
    super(topLeft, bottomRight);
    this.minValue = minValue;
    this.maxValue = maxValue;
    if (isAtEnd) {
      this.currentX = this.bottomRight.x;
    } else {
      this.currentX = this.topLeft.x;
    }
    this.mapCurrentValue();
  }

  public void draw() {
    colorMode(RGB, 255, 255, 255);
    this.drawScroller();
    this.drawSlider();
    this.drawLadder();
    this.mapCurrentValue();
  }

  private void drawScroller() {
    fill(color(209));
    noStroke();
    rect(this.topLeft.x, this.topLeft.y, this.rectWidth, this.rectHeight);
  }

  private void drawSlider() {
    strokeWeight(10);
    stroke(0);
    line(currentX, this.topLeft.y, currentX, this.bottomRight.y);
  }

  private void drawLadder() {
    textSize(10);
    fill(color(0));
    strokeWeight(1);
    stroke(0);

    float x = this.topLeft.x;
    float step = this.rectWidth / 20;
    int i = 0;
    while (x <= this.bottomRight.x) {
      line(x, this.topLeft.y + 10, x, this.bottomRight.y - 10);
      int valToDisplay = int(map(x, this.topLeft.x, this.bottomRight.x, this.minValue, this.maxValue));

      if (i % 2 == 0) {
        text("" + valToDisplay, x, this.bottomRight.y - 3);
      }
      else {
        text("" + valToDisplay, x, this.topLeft.y + 7); 
      }
        
      x += step;
      i++;
    }
  }

  @Override
    protected void onDragged() {
    currentX = mouseX;
    if (currentX < this.topLeft.x) currentX = this.topLeft.x;
    if (currentX > this.bottomRight.x) currentX = this.bottomRight.x;
  }

  public void drawBorders() {
    line(this.topLeft.x, this.topLeft.y + this.rectHeight/2, this.bottomRight.x, this.topLeft.y + rectHeight/2);
  }

  private void mapCurrentValue() {
    this.currentValue = map(this.currentX, this.topLeft.x, this.bottomRight.x, this.minValue, this.maxValue);
  }
}
