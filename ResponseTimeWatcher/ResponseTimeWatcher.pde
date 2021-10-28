import oscP5.*;
import netP5.*;

final int N_CHANNELS = 4;
final int N_CHANNELS_OUT=7; // 4センサ+額2つ平均+耳2つ平均+全センサ平均
final int N_BANDS = 5;
final int BUFFER_SIZE = 220;
float[][][] buffer = new float[N_BANDS][N_CHANNELS_OUT][BUFFER_SIZE];
int[] pointer = { 0, 0, 0, 0, 0 };
float[] average_state=new float[N_BANDS][N_CHANNELS_OUT];

final String[] LABELS = new String[] {
  "TP9", "FP1", "FP2", "TP10", "FP_avg", "TP_avg", "All_avg"
};
final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);

final int AVERAGE_RANGE=64;

float average(int band,int[] channels){
  float result=0;
  int n=0;
  int current_pointer;
  for(int c in channels){
    for(int i=0;i<AVERAGE_RANGE;i++){
      current_pointer=(pointer[band]-i+BUFFER_SIZE)%BUFFER_SIZE; // 負にならないようBUFFER_SIZEを足している
      if(buffer[band][c][current_pointer]==0) continue;
      result+=buffer[band][c][current_pointer];
      n++;
    }
  }
  return result/n;
}

void oscEvent(OscMessage msg){
  int band;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")) band = 0;
  else if(msg.checkAddrPattern("/muse/elements/beta_relative")) band=1;
  else if(msg.checkAddrPattern("/muse/elements/gamma_relative")) band=2;
  else if(msg.checkAddrPattern("/muse/elements/delta_relative")) band=3;
  else if(msg.checkAddrPattern("/muse/elements/theta_relative")) band=4;

  for(int ch = 0; ch < N_CHANNELS; ch++){
    buffer[band][ch][pointer[band]] = msg.get(ch).floatValue();
  }
  buffer[band][N_CHANNELS+0][pointer[band]]=(buffer[band][1][pointer[band]]+buffer[band][2][pointer[band]])/2;
  buffer[band][N_CHANNELS+1][pointer[band]]=(buffer[band][0][pointer[band]]+buffer[band][3][pointer[band]])/2;
  buffer[band][N_CHANNELS+2][pointer[band]]=(buffer[band][N_CHANNELS+0][pointer[band]]+buffer[band][N_CHANNELS+1][pointer[band]])/2;

  for(int ch = 0; ch < N_CHANNELS; ch++){
    average_state[band][ch]=average(band,{ch});
  }
  average_state[band][N_CHANNELS+0]=average(band,{1,2});
  average_state[band][N_CHANNELS+1]=average(band,{0,3});
  average_state[band][N_CHANNELS+2]=average(band,{0,1,2,3});
  
  pointer[band] = (pointer[band] + 1) % BUFFER_SIZE;
}
