// 脳波グラフと矢印を描くウィンドウの描画処理を行う

class GraphWindow extends BaseWindow {
  private BrainWaveStorage storage;
  private final int GRAPH_X=25, GRAPH_Y=25;
  private final int GRAPH_WIDTH=350,GRAPH_HEIGHT=350;

  final float DISPLAY_SCALE = -100.0;
  final int offsetX, offsetY;
  final color BG_COLOR = color(0, 0, 0);
  final color AXIS_COLOR = color(255, 0, 0);
  final color GRAPH_COLOR = color(0, 0, 255);

  GraphWindow(PApplet parent, int x, int y, int w, int h, BrainWaveStorage storage){
    super(parent,x,y,w,h);
    this.storage = storage;
    offsetX = (GRAPH_WIDTH-BrainWaveStorage.BUFFER_SIZE)/2;
    offsetY = GRAPH_HEIGHT/2;
  }

  void drawContent(PGraphics g){
    g.background(FILL_COLOR);
    g.smooth();
    g.background(BG_COLOR);
    // グラフ描画
    int x1, y1, x2, y2;
    for(int t = 0; t < storage.BUFFER_SIZE; t++){
      g.stroke(GRAPH_COLOR);
      x1 = offsetX+t;
      y1 = offsetY+int(storage.fromAverageBuffer(t+storage.getPointer())*DISPLAY_SCALE);
      x2 = offsetX+t+1;
      y2 = offsetY+int(storage.fromAverageBuffer(t+1+storage.getPointer())*DISPLAY_SCALE);
      g.line(x1, y1, x2, y2);
    }
    // 軸描画
    g.stroke(AXIS_COLOR);
    x1 = offsetX;
    y1 = offsetY;
    x2 = offsetX+storage.BUFFER_SIZE;
    y2 = offsetY;
    g.line(x1, y1, x2, y2);

    x1 = offsetX;
    y1 = offsetY-int(DISPLAY_SCALE/2);
    x2 = offsetX;
    y2 = offsetY+int(DISPLAY_SCALE/2);
    g.line(x1, y1, x2, y2);

    // 閾値描画
    x1 = offsetX;
    y1 = offsetY+int(0.3f*DISPLAY_SCALE);
    x2 = GRAPH_WIDTH;
    y2 = y1;
    g.line(x1, y1, x2, y2);
  }
}
