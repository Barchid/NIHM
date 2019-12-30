class FilterShapes extends RectWidget {
  public boolean ghostDisplayed = true;
  public boolean villageDisplayed = true;
  public boolean bourgDisplayed = true;
  public boolean petiteVilleDisplayed = true;
  public boolean moyenneVilleDisplayed = true;
  public boolean grandeVilleDisplayed = true;
  public boolean metropoleDisplayed = true;
  
  private Checkbox ghostBox;
  private Checkbox villageBox;
  private Checkbox bourgBox;
  private Checkbox petiteVilleBox;
  private Checkbox moyenneVilleBox;
  private Checkbox grandeVilleBox;
  private Checkbox metropoleBox;
  
  public FilterShapes(PVector topLeft, PVector bottomRight) {
    super(topLeft, bottomRight);
    // Hard-codé parce que j'en ai ma claque...
    this.ghostBox = new Checkbox(805, 565-15);
    this.villageBox = new Checkbox(805, 600-15);
    this.bourgBox = new Checkbox(805, 635-15);
    this.petiteVilleBox = new Checkbox(805, 670-15);
    this.moyenneVilleBox = new Checkbox(805, 705-15);
    this.grandeVilleBox = new Checkbox(805, 740-15);
    this.metropoleBox = new Checkbox(805, 775-15);
  }
  
  public void draw() {
    this.updateFlags();
    
    // draw boxes
    this.ghostBox.draw();
    this.villageBox.draw();
    this.bourgBox.draw();
    this.petiteVilleBox.draw();
    this.moyenneVilleBox.draw();
    this.grandeVilleBox.draw();
    this.metropoleBox.draw();
    
    // draw
    
    // draw le texte
    colorMode(RGB);
    fill(0);
    textSize(12);
    text("Village fantôme ( < 10 habitants)", 830, 565);
    text("Village ( >= 10 et < 2k habitants)", 830, 600);
    text("Bourg ( >= 2k et < 5k habitants)", 830, 635);
    text("Petite ville ( >= 5k et < 20k habitants)", 830, 670);
    text("Moyenne ville ( >= 20k et < 50k habitants)", 830, 705);
    text("Grande ville ( >= 50k et < 200k habitants)", 830, 740);
    text("Metropole ( >= 200k habitants", 830, 775);
  }
  
  private void updateFlags() {
    this.ghostDisplayed = this.ghostBox.b;
    this.villageDisplayed = this.villageBox.b;
    this.bourgDisplayed = this.bourgBox.b;
    this.petiteVilleDisplayed = this.petiteVilleBox.b;
    this.moyenneVilleDisplayed = this.moyenneVilleBox.b;
    this.grandeVilleDisplayed = this.grandeVilleBox.b;
    this.metropoleDisplayed = this.metropoleBox.b;
  }
  
  @Override
  protected void onMouseClicked() {
    this.ghostBox.click();
    this.villageBox.click();
    this.bourgBox.click();
    this.petiteVilleBox.click();
    this.moyenneVilleBox.click();
    this.grandeVilleBox.click();
    this.metropoleBox.click();
  }
  
  void drawShape(int x, int y, PShape s) {
    fill(color(0));
    shapeMode(CENTER);
    shape(s, x, y, 10, 10);
  }
}
