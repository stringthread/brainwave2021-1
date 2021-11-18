class LinkLine{
  final int TERMINAL_RADIUS=36, TERMINAL_STROKE_WEIGHT=6, LINE_WEIGHT=6;
  final color TERMINAL_FILL_COLOR=color(255), TERMINAL_STROKE_COLOR=color(70), LINE_COLOR=color(92,214,92);
  PApplet parent;
  int x1,y1,x2,y2;
  LinkLine(PApplet parent, int x1, int y1, int x2, int y2){
    this.parent=parent;
    this.x1=x1;
    this.y1=y1;
    this.x2=x2;
    this.y2=y2;
  }
  void draw(){
    strokeWeight(LINE_WEIGHT);
    stroke(LINE_COLOR);
    parent.line(x1,y1,x2,y2);
    strokeWeight(TERMINAL_STROKE_WEIGHT);
    stroke(TERMINAL_STROKE_COLOR);
    fill(TERMINAL_FILL_COLOR);
    ellipse(x1,y1,TERMINAL_RADIUS,TERMINAL_RADIUS);
    ellipse(x2,y2,TERMINAL_RADIUS,TERMINAL_RADIUS);
  }
}
