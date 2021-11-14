// 実行用ファイル

import oscP5.*;

BrainWaveStorage bws;
FluctuationDetector fd;
SoundController sc;
DrawingWindow dw;
GraphWindow gw;
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
  dw=new DrawingWindow(this,0,0,dwSize,dwSize,fd);
  gw=new GraphWindow(this,height,0,540,400,bws);
  dw.start();
  prevTimeUpdated=millis();
  startAt=millis();
  frameRate(60);
}
void draw(){
  background(255); // 適当に設定
  if(!dw.isDrawing()&&millis()-startAt>=5000) dw.start();
  if(millis()>=prevTimeUpdated+TIMEUNIT){
    sc.step();
    if(dw.isDrawing()) dw.step();
    prevTimeUpdated=millis();
  }
  fd.draw();
  sc.draw();
  dw.draw();
  gw.draw();
}
void oscEvent(OscMessage msg){
  bws.oscEvent(msg);
}
