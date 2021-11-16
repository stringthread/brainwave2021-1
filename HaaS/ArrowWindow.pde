// 矢印を描くウィンドウの描画処理を行う

class ArrowWindow extends BaseWindow {
  private final int X_PADDING=25,Y_PADDING=50;
  private final int ARROW_WIDTH, ARROW_HEIGHT;
  private PImage arrowBack;
  private boolean isArrowMoving,isArrowLightOn;
  public void setIsArrowMoving(boolean val){ isArrowMoving=val; }
  private int yBorderTop=0;
  private final int BORDER_WEIGHT=20, BORDER_INTERVAL=60;
  private final int BORDER_SPEED=2; // ボーダーの下降速度[px/frame]

  ArrowWindow(PApplet parent, int x, int y, int w, int h){
    super(parent,x,y,w,h);
    ARROW_WIDTH=this.w-X_PADDING*2;
    ARROW_HEIGHT=this.h-Y_PADDING*2;
    // 矢印画像の読み込みとサイズ調整
    arrowBack=loadImage("arrow1_back.png");
    arrowBack.resize(ARROW_WIDTH, ARROW_HEIGHT);
  }

  void drawContent(PGraphics g){
    g.beginDraw();
    g.background(FILL_COLOR);
    g.noStroke();
    g.fill(32);
    g.rect(X_PADDING, Y_PADDING, ARROW_WIDTH, ARROW_HEIGHT);
    if(isArrowMoving){
      // 縞模様の描画
      g.fill(150,240,50);
      for(int y=yBorderTop-BORDER_INTERVAL; y<ARROW_HEIGHT; y+=BORDER_INTERVAL){
        g.rect(X_PADDING, y+Y_PADDING, ARROW_WIDTH, BORDER_WEIGHT);
      }
    }
    yBorderTop+=BORDER_SPEED; if(yBorderTop>=BORDER_INTERVAL) yBorderTop-=BORDER_INTERVAL;
    g.tint(FILL_COLOR); // 画像の白をFILL_COLORに変更
    g.image(arrowBack, X_PADDING, Y_PADDING);
    g.noTint();
    g.endDraw();
  }
}
