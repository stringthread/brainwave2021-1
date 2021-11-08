// 絵を描くウィンドウの描画処理を行う

import java.util.Arrays;

static enum State {
  UNINITIALIZED(127), BLACK(0), WHITE(255);
  private final int _color;
  public int getColor(){ return _color; }
  State(final int _color){
    this._color=_color;
  }
}

class DrawingWindow extends BaseWindow{
  private final int UNIT_WIDTH, UNIT_HEIGHT; // 1マスの幅と高さ [px]
  private final int N_WIDTH=48, N_HEIGHT=13; // 横のマス数と縦のマス数
  private final int TIMEUNIT=100; // マスの値を更新する時間間隔 [ms]
  private State[] pixels=new State[UNIT_HEIGHT*UNIT_WIDTH];
  private int pointer;
  private int startTime;
  private boolean isDrawing;
  private FluctuationDetector fd;

  DrawingWindow(PApplet parent, int x, int y, int w, int h, FluctuationDetector fd){
    super(parent,x,y,w,h);
    this.fd=fd;
    UNIT_WIDTH=w/N_WIDTH;
    UNIT_HEIGHT=h/N_HEIGHT;
    reset();
  }
  void reset(){
    Arrays.fill(pixels,State.UNINITIALIZED);
    pointer=0;
    startTime=parent.millis();
  }
  void start(){
    reset();
    isDrawing=true;
  }
  void drawContent(PGraphics g){
    if(isDrawing && parent.millis()>=startTime+TIMEUNIT*pointer){
      pixels[pointer]=fd.isActive()?State.BLACK:State.WHITE;
      pointer++;
      if(pointer>=pixels.length){
        isDrawing=false;
      }
    }
    g.noStroke();
    for(int y=0;y<UNIT_HEIGHT;y++){
      for(int x=0;x<UNIT_WIDTH;x++){
        g.fill(pixels[y*UNIT_WIDTH+x].getColor());
        g.rect(UNIT_WIDTH*x, UNIT_HEIGHT*y, UNIT_WIDTH, UNIT_HEIGHT);
      }
    }
  }
}