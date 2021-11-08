// 脳波グラフと矢印を描くウィンドウの描画処理を行う

class GraphWIndow extends BaseWindow {
  private BrainWaveStorage storage;
  private PGraphics gGraph, gArrow;
  private final int GRAPH_X, GRAPH_Y;
  private final int GRAPH_WIDTH,GRAPH_HEIGHT;
  private final int ARROW_X, ARROW_Y;
  private final int ARROW_WIDTH,ARROW_HEIGHT;

  final float DISPLAY_SCALE = -200.0;
  final int offsetY;
  final color BG_COLOR = color(0, 0, 0);
  final color AXIS_COLOR = color(255, 0, 0);
  final color GRAPH_COLOR = color(0, 0, 255);

  DrawingWindow(PApplet parent, int x, int y, int w, int h, BrainWaveStorage storage){
    super(parent,x,y,w,h);
    this.storage = storage;
    gGraph = this.parent.createGraphics(GRAPH_WIDTH,GRAPH_HEIGHT);
    gArrow = this.parent.createGraphics(ARROW_WIDTH,ARROW_HEIGHT);
    offsetY = h/2;
    BG_COLOR = this.parent.color(0, 0, 0);
    AXIS_COLOR = this.parent.color(255, 0, 0);
    GRAPH_COLOR = this.parent.color(0, 0, 255);
  }

  private void drawGraph(){
    gGraph.beginDraw();
    gGraph.smooth();
    gGraph.background(BG_COLOR);
    // グラフ描画
    for(int t = 0; t < storage.BUFFER_SIZE; t++){
      gGraph.stroke(GRAPH_COLOR);
      x1 = t;
      y1 = offsetY+storage.fromAverageBuffer(t+storage.getPointer())*DISPLAY_SCALE;
      x2 = t+1;
      y2 = offsetY+storage.fromAverageBuffer(t+1+storage.getPointer())*DISPLAY_SCALE;
      gGraph.line(x1, y1, x2, y2);
    }
    // 軸描画
    gGraph.stroke(AXIS_COLOR);
    x1 = offsetX;
    y1 = offsetY;
    x2 = offsetX+storage.BUFFER_SIZE;
    y2 = offsetY;
    gGraph.line(x1, y1, x2, y2);
    gGraph.endDraw();
  }

  private void drawArrow(){
  }

  void drawContent(PGraphics g){
    drawGraph();
    drawArrow();
    g.image(gGraph, GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT);
    g.image(gArrow, ARROW_X, ARROW_Y, ARROW_WIDTH, ARROW_HEIGHT);
  }
}