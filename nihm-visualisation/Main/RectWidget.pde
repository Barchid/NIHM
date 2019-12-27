// Classe représentant un Widget rectangulaire dans notre application de visualisation
abstract class RectWidget {
  // Coin supérieur gauche du rectangle
  public PVector topLeft;
  
  // Coin inférieur droit du rectangle
  public PVector bottomRight;
  
  // centre du rectangle, champ dénormalisé
  public PVector center;
  
  // Largeur du rectangle
  public float rectWidth;
  
  // Hauteur du rectangle
  public float rectHeight;
  
  // Flag indiquant que l'utilisateur a pressé sur le widget et ne relâche pas encore son clic 
  public boolean isLocked = false;
  
  public RectWidget(PVector topLeft, PVector bottomRight) {
    this.topLeft = topLeft;
    this.bottomRight = bottomRight;
    
    // Calcul du centre du rectangle
    this.center = new PVector(
      (this.topLeft.x + this.bottomRight.x) / 2,
      (this.topLeft.y + this.bottomRight.y) / 2
    );
    
    // Calcul de la hauteur et la largeur du rectangle
    this.rectWidth = (this.bottomRight.x - this.topLeft.x);
    this.rectHeight = (this.bottomRight.y - this.topLeft.y);
  }
  
  // Méthode qui renvoie true si le curseur de la souris est à l'intérieur du rectangle
  public boolean isOver() {
    return (
      mouseX >= topLeft.x && 
      mouseX <= bottomRight.x &&
      mouseY >= topLeft.y &&
      mouseY <= bottomRight.y
    );
  }
  
  public void mouseClicked(){
    if(this.isOver()) {
      this.onMouseClicked();
    }
  }
  
  public void mousePressed() {
    if(this.isOver()){
       this.isLocked = true; 
    }
  }
  
  public void mouseDragged() {
    if(this.isLocked) {
      this.onDragged();
    }
  }
  
  public void mouseReleased() {
    this.isLocked = false;
  }
  
  public void mouseWheel(MouseEvent event) {
    if(this.isOver()) {
      this.onMouseWheel(event);
    }
  }
  
  // Callback utilisé quand l'utilisateur a draggé le widget
  protected void onDragged() {}
  
  // Callback appelé quand l'utilisateur fait un scroll sur le widget
  protected void onMouseWheel(MouseEvent event) {}
  
  // Callback appelé quand l'utilisateur clique sur le widget
  protected void onMouseClicked() {}
  
  // Fonction de dessin
  public void draw() {
    
  }
  
  // Méthode qui dessine les limites du widgets (en lignes noires)
  public void drawBorders() {
    // On considère ici q'on est en mode RGB, rectMode = CORNER et en noFill()
    rect(this.topLeft.x, this.topLeft.y, this.rectWidth, this.rectHeight);
  }
}
