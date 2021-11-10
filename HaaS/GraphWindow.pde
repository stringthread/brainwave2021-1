// 脳波グラフと矢印を描くウィンドウの描画処理を行う

class GraphWIndow extends BaseWindow {
  private BrainWaveStorage storage;
  private PGraphics gGraph, gArrow;
  private final int GRAPH_X=25, GRAPH_Y=25;
  private final int GRAPH_WIDTH=350,GRAPH_HEIGHT=350;
  private final int ARROW_X=420, ARROW_Y=50;
  private final int ARROW_WIDTH=100,ARROW_HEIGHT=300;

  final float DISPLAY_SCALE = -200.0;
  final int offsetY;
  final color BG_COLOR = color(0, 0, 0);
  final color AXIS_COLOR = color(255, 0, 0);
  final color GRAPH_COLOR = color(0, 0, 255);

  private PImage arrowOuter, arrowLight, arrowDark;
  private boolean isArrowMoving,isArrowLightOn;
  public void setIsArrowMoving(boolean val){ isArrowMoving=val; }
  private int yBorderTop=0;
  private int framesCounter=0;
  private final int BORDER_WEIGHT=20, BORDER_INTERVAL=60;

  DrawingWindow(PApplet parent, int x, int y, int w, int h, BrainWaveStorage storage){
    super(parent,x,y,w,h);
    this.storage = storage;
    gGraph = this.parent.createGraphics(GRAPH_WIDTH,GRAPH_HEIGHT);
    gArrow = this.parent.createGraphics(ARROW_WIDTH,ARROW_HEIGHT);
    offsetY = h/2;
    BG_COLOR = this.parent.color(0, 0, 0);
    AXIS_COLOR = this.parent.color(255, 0, 0);
    GRAPH_COLOR = this.parent.color(0, 0, 255);
    // 矢印画像の読み込みとサイズ調整
    arrowOuter=loadImage("arrow1_outer.png");
    arrowOuter.resize(ARROW_WIDTH, ARROW_HEIGHT);
    arrowDark=loadImage("arrow1_dark.png");
    arrowDark.resize(ARROW_WIDTH, ARROW_HEIGHT);
    arrowLight=loadImage("arrow1_inner_white.png");
    arrowLight.resize(ARROW_WIDTH, ARROW_HEIGHT);
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
    gArrow.beginDraw();
    gArrow.background(255);
    gArrow.noStroke();
    gArrow.fill(32);
    gArrow.rect(0, 0, ARROW_WIDTH, ARROW_HEIGHT);
    if(isArrowMoving){
      // 縞模様の描画
      gArrow.fill(150,240,50);
      for(int y=yBorderTop-BORDER_INTERVAL; y<ARROW_HEIGHT; y+=BORDER_INTERVAL){
        gArrow.rect(0, y, ARROW_WIDTH, BORDER_WEIGHT);
      }
      // 40フレームごとに中を明滅
      if(framesCounter%40==0) { isArrowLightOn=!isArrowLightOn; framesCounter=0; }
    }
    yBorderTop+=2; if(yBorderTop>=BORDER_INTERVAL) yBorderTop-=BORDER_INTERVAL;
    gArrow.image(arrowOuter, 0, 0);
    gArrow.image((!isArrowMoving||isArrowLightOn)?arrowLight:arrowDark, 0, 0);
    framesCounter++;
    gArrow.endDraw();
  }

  void drawContent(PGraphics g){
    drawGraph();
    drawArrow();
    g.image(gGraph, GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT);
    g.image(gArrow, ARROW_X, ARROW_Y, ARROW_WIDTH, ARROW_HEIGHT);
  }
}