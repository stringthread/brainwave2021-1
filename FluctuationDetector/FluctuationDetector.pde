import oscP5.*;
import netP5.*;

final int N_CHANNELS = 4;
final int N_BANDS = 5;
final int BUFFER_SIZE = 220;
// final float MAX_MICROVOLTS = 1682.815;
// final float DISPLAY_SCALE = 200.0;
// from:https://sites.google.com/a/interaxon.ca/muse-developer-site/museio/osc-paths/osc-paths---v3-6-0#TOC-Raw-FFTs-for-Each-Channel
final float DISPLAY_SCALE = - 200.0;
final String[] LABELS = new String[] {
  "TP9", "FP1", "FP2", "TP10"
};

final color BG_COLOR = color(0, 0, 0);
final color BG_ACTIVE_COLOR = color(0, 127, 0);
final color AXIS_COLOR = color(255, 0, 0);
// final color GRAPH_COLOR = color(0, 0, 255);
final color GRAPH_COLOR = color(255, 0, 0);
final color LABEL_COLOR = color(255, 255, 0);
final int LABEL_SIZE = 21;

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);

float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
float[][] average_buffer=new float[N_CHANNELS][BUFFER_SIZE];
int pointer = 0;
float[] offsetX = new float[N_CHANNELS];
float[] offsetY = new float[N_CHANNELS];

boolean is_active, is_active_prev;

void setup(){
  size(1000, 600);
  frameRate(30);
  smooth();
  for(int ch = 0; ch < N_CHANNELS; ch++){
    offsetX[ch] = (width / N_CHANNELS) * ch + 15;
    offsetY[ch] = height / 2;
  }
}

void draw(){
  float x1, y1, x2, y2;
  background(is_active?BG_ACTIVE_COLOR:BG_COLOR);

  for(int band = 0; band < 3; band++){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      for(int t = 0; t < BUFFER_SIZE; t++){
        stroke(GRAPH_COLOR);
        x1 = offsetX[ch] + t;
        y1 = offsetY[ch] + average_buffer[ch][(t + pointer) % BUFFER_SIZE] * DISPLAY_SCALE;
        x2 = offsetX[ch] + t + 1;
        y2 = offsetY[ch] + average_buffer[ch][(t + 1 + pointer) % BUFFER_SIZE] * DISPLAY_SCALE;
        line(x1, y1, x2, y2);
      }
    }
  }

  for(int ch = 0; ch < N_CHANNELS; ch++){
    stroke(AXIS_COLOR);
    x1 = offsetX[ch];
    y1 = offsetY[ch];
    x2 = offsetX[ch] + BUFFER_SIZE;
    y2 = offsetY[ch];
    line(x1, y1, x2, y2);
  }

  fill(LABEL_COLOR);
  textSize(LABEL_SIZE);
  for(int ch = 0; ch < N_CHANNELS; ch++){
    text(LABELS[ch], offsetX[ch], offsetY[ch]);
  }

}

final int AVERAGE_RANGE=60; // 6秒間で移動平均
final int THRESHOLD_TIME_LATENCY=50; // 2秒前を基準に閾値計算
final float THRESHOLD_DIFFERENCE=0.3; // 2秒前からの下げ幅

float average(int ch){
  float result=0;
  int current_pointer;
  for(int i=0;i<AVERAGE_RANGE;i++){
    current_pointer=(pointer-i+BUFFER_SIZE)%BUFFER_SIZE; // 負にならないようBUFFER_SIZEを足している
    result+=buffer[ch][current_pointer];
  }
  return result/AVERAGE_RANGE;
}

void oscEvent(OscMessage msg){
  float data;
  if(msg.checkAddrPattern("/muse/elements/alpha_absolute")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      buffer[ch][pointer] = data;
      average_buffer[ch][pointer] = average(ch);
    }
    int compared_pointer=(pointer-THRESHOLD_TIME_LATENCY+BUFFER_SIZE)%BUFFER_SIZE;
    final int DETECTED_CH=0;
    is_active_prev=is_active;
    is_active=average_buffer[DETECTED_CH][pointer]<average_buffer[DETECTED_CH][compared_pointer]-THRESHOLD_DIFFERENCE;
    pointer = (pointer + 1) % BUFFER_SIZE;
  }
}
