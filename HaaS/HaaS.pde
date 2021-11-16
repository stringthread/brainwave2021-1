// 実行用ファイル

import oscP5.*;

BrainWaveStorage bws;
FluctuationDetector fd;
SoundController sc;
DrawingWindow dw;
GraphWindow gw;
ArrowWindow aw;
LinkLine link;
final int BLACK_W=200;
final int TIMEUNIT=500; // マスの値を更新する時間間隔 [ms]
int prevTimeUpdated, startAt;

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);

void settings(){
  fullScreen();
}

void setup(){
  bws=new BrainWaveStorage();
  fd=new FluctuationDetector(bws);
  sc=new SoundController(this);
  int dwSize=min(height,width-540);
  dw=new DrawingWindow(this,0,(height-dwSize)/2,dwSize,dwSize,fd);
  gw=new GraphWindow(this, width-BLACK_W-520, height/2-150, 520,300,bws);
  link=new LinkLine(this,dwSize,height/2,width-BLACK_W-520,height/2);
  aw=new ArrowWindow(this, width-175, height/2-125, 150,250);
  prevTimeUpdated=millis();
  startAt=millis();
  frameRate(60);
}
void draw(){
  background(255); // 適当に設定
  fill(0);
  noStroke();
  rect(width-BLACK_W, 0, BLACK_W, height);
  if(!sc.isRunning()&&millis()-startAt>=6000){
    sc.start();
    fd.restart();
  }
  if(!dw.isDrawing()&&millis()-startAt>=9000) dw.start();
  if(millis()>=prevTimeUpdated+TIMEUNIT){
    sc.step();
    if(dw.isDrawing()) dw.step();
    prevTimeUpdated=millis();
  }
  fd.draw();
  sc.draw();
  dw.draw();
  gw.draw();
  link.draw();
  aw.setIsArrowMoving(sc.soundfile.isPlaying());
  aw.draw();
}
void oscEvent(OscMessage msg){
  bws.oscEvent(msg);
}
