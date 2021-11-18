// 矢印を描くウィンドウの描画処理を行う

class ArrowWindow extends BaseWindow {
  private final int X_PADDING=25,Y_PADDING=50;
  private PImage arrowBack;
  private boolean isArrowMoving,isArrowLightOn;
  public void setIsArrowMoving(boolean val){ isArrowMoving=val; }
  private int yBorderTop=0;
  private final int BORDER_WEIGHT=20, BORDER_INTERVAL=40;
  private final int BORDER_SPEED=2; // ボーダーの下降速度[px/frame]

  ArrowWindow(PApplet parent, int x, int y, int w, int h){
    super(parent,x,y,w,h);
    // 独自のPaddingで再調整
    this.x=x+X_PADDING;
    this.y=y+Y_PADDING;
    this.w=w-X_PADDING*2;
    this.h=h-Y_PADDING*2;
    this.content=parent.createGraphics(this.w,this.h);
    // 矢印画像の読み込みとサイズ調整
    arrowBack=loadImage("arrow1_back.png");
    arrowBack.resize(this.w, this.h);
  }

  void drawContent(PGraphics g){
    g.background(FILL_COLOR);
    g.noStroke();
    g.fill(32);
    g.rect(0, 0, w, h);
    if(isArrowMoving){
      // 縞模様の描画
      g.fill(150,240,50);
      for(int y=yBorderTop-BORDER_INTERVAL; y<h; y+=BORDER_INTERVAL){
        g.rect(0, y, w, BORDER_WEIGHT);
      }
    }
    yBorderTop+=BORDER_SPEED; if(yBorderTop>=BORDER_INTERVAL) yBorderTop-=BORDER_INTERVAL;
    g.tint(FILL_COLOR); // 画像の白をFILL_COLORに変更
    g.image(arrowBack, 0, 0);
    g.noTint();
  }
}
