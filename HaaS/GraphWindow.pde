// 脳波グラフと矢印を描くウィンドウの描画処理を行う

class GraphWindow extends BaseWindow {
  private BrainWaveStorage storage;

  final float VALUE_RANGE=.8f; // グラフに描画したい値の変化幅
  final float displayScale;
  final int offsetX, offsetY, graphW, graphH;
  final color AXIS_COLOR = color(255, 0, 0);
  final color THRESHOLD_COLOR = color(255, 168, 0);
  final color GRAPH_COLOR = color(0, 0, 255);

  GraphWindow(PApplet parent, int x, int y, int w, int h, BrainWaveStorage storage){
    super(parent,x,y,w,h);
    this.storage = storage;
    offsetX = (this.w % BrainWaveStorage.BUFFER_SIZE)/2;
    graphW = this.w - offsetX*2;
    graphH = this.h;
    offsetY = int(graphH*0.7);
    displayScale = - graphH / VALUE_RANGE;
  }

  void drawContent(PGraphics g){
    g.background(FILL_COLOR);
    g.smooth();
    g.strokeWeight(2);
    // グラフ描画
    int x1, y1, x2, y2;
    for(int t = 0; t < storage.BUFFER_SIZE; t++){
      g.stroke(GRAPH_COLOR);
      x1 = offsetX+t;
      y1 = offsetY+int(storage.fromAverageBuffer(t+storage.getPointer())*displayScale);
      x2 = offsetX+t+1;
      y2 = offsetY+int(storage.fromAverageBuffer(t+1+storage.getPointer())*displayScale);
      g.line(x1, y1, x2, y2);
    }
    // 軸描画
    g.stroke(AXIS_COLOR);
    x1 = offsetX;
    y1 = offsetY;
    x2 = offsetX+graphW;
    y2 = offsetY;
    g.line(x1, y1, x2, y2);

    x1 = offsetX;
    y1 = (this.h-graphH)/2;
    x2 = offsetX;
    y2 = y1+graphH;
    g.line(x1, y1, x2, y2);

    // 閾値描画
    g.stroke(THRESHOLD_COLOR);
    x1 = offsetX;
    y1 = offsetY+int(0.3f*displayScale);
    x2 = graphW;
    y2 = y1;
    g.line(x1, y1, x2, y2);
  }
}
