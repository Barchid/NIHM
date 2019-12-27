// From https://forum.processing.org/two/discussion/4849/checkbox

class Checkbox {
  int x, y;
  boolean b;
  Checkbox(int x, int y){
    this.x = x;
    this.y = y;
    this.b = false;
  }
  void draw(){
    stroke(0);
    rect(x, y, 20, 20);
    if(b){
      line(x, y, x+20, y+20);
      line(x, y+20, x+20, y);
    }
  }
  void click(){
    if(isOver()){
      b=!b;
    }
  }
  boolean isOver(){
    return(mouseX>x&&mouseX<x+20&&mouseY>y&&mouseY<y+20);
  }
}
