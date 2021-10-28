import oscP5.*;
import netP5.*;
import processing.sound.*;

final int N_CHANNELS = 4;
final int N_CHANNELS_OUT=7; // 4センサ+額2つ平均+耳2つ平均+全センサ平均
final int N_BANDS = 5;
final int BUFFER_SIZE = 220;
float[][][] buffer = new float[N_BANDS][N_CHANNELS_OUT][BUFFER_SIZE];
int[] pointer = { 0, 0, 0, 0, 0 };
float[] average_state=new float[N_BANDS][N_CHANNELS_OUT];

final String[] BAND_LABELS = new String[] {
  "alpha","beta","gamma","delta","theta"
};
final String[] CH_LABELS = new String[] {
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

final int FPS=60;
final int AUDIO_DURATION=5000; // 音声を流す長さ[ms]
final int AUDIO_INTERVAL=2000; // 音声を流す間隔[ms]
final int N_LOOPS=20; // 音声のON/OFFの繰り返し個数

SoundFile song;
int play_state_changed_at;
int loop_counter=0;

void setup(){
  frameRate(FPS);
  song=new SoundFile(this,"sample.mp3");
  play_state_changed_at=millis(); // NOTE: 本来は閾値補正のための時間を取ってからだが、テスト用ツールのため省略
}

void draw(){
  if(song.isPlaying()){
    if(millis()-play_state_changed_at>=AUDIO_DURATION){
      song.stop();
      play_state_changed_at=millis();
      loop_counter++;
    }
  } else {
    if(millis()-play_state_changed_at>=AUDIO_INTERVAL){
      song.loop();
      play_state_changed_at=millis();
    }
  }
  if(loop_counter>=N_LOOPS) exit();
}

void dispose(){
  JSONObject json_root=new JSONObject();
  json_root.setInt("Audio_Interval", AUDIO_INTERVAL);
  json_root.setInt("Average_Range", AVERAGE_RANGE);
  JSONObject json_threshold=new JSONObject();
  JSONObject json_threshold_band=new JSONObject();
  for(int b=0;b<N_BANDS;b++){
    json_threshold_band=new JSONObject();
    for(int c=0;c<N_CHANNELS_OUT;c++){
      json_threshold_band.setFloat(CH_LABELS[c],WAVE_THRESHOLD[b][c]);
    }
    json_threshold.setJSONObject(BAND_LABELS[b],json_threshold_band);
  }
  json_root.setJSONObject("Thresholds", json_threshold);
  JSONObject json_band=new JSONObject();
  JSONArray json_ch=new JSONArray();
  JSONObject json_unit=new JSONObject();
  for(int b=0;b<N_BANDS;b++){
    json_band=new JSONObject()
    for(int c=0;c<N_CHANNELS_OUT;c++){
      json_ch=new JSONArray();
      for(int i=0;i<N_LOOPS;i++){
        json_unit=new JSONObject();
        json_unit.setFloat("RT_in",rt_in[b][c][i]);
        json_unit.setFloat("RT_out",rt_out[b][c][i]);
        json_unit.setFloat("False_positives",n_false_positive[b][c][i]);
        json_unit.setFloat("False_negatives",n_false_negative[b][c][i]);
        json_ch.setJSONObject(i,json_unit);
      }
      json_band.setJSONArray(CH_LABELS[c],json_ch);
    }
    json_root.setJSONObject(BAND_LABELS[b], json_band);
  }
  saveJSONObject(json_root,"out_interval_"+nf(AUDIO_INTERVAL)+"_range_"+nf(AVERAGE_RANGE)+".json");
}

final float[][] WAVE_THRESHOLD={
  {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f},
  {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f},
  {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f},
  {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f},
  {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f}
}; // WAVE_THRESHOLD[band][ch]: 各バンド・チャネルの閾値
float[][][] rt_in=new float[N_BANDS][N_CHANNELS_OUT][N_LOOPS]; // 音声オン→閾値の反応時間
float[][][] rt_out=new float[N_BANDS][N_CHANNELS_OUT][N_LOOPS]; // 音声オフ→閾値の反応時間
boolean[][] is_active=new boolean[N_BANDS][N_CHANNELS_OUT]; // 各バンド・チャネルで現在時点で閾値以上か表す
int[][][] n_false_positive=new float[N_BANDS][N_CHANNELS_OUT][N_LOOPS]; // 各ループでの偽陽性数
int[][][] n_false_negative=new float[N_BANDS][N_CHANNELS_OUT][N_LOOPS]; // 各ループでの偽陰性数

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

  for(int ch=0;ch<N_CHANNELS_OUT;ch++){
    // 現在のaverage_stateの値がactiveなものか判定
    boolean current_active_state=(average_state[band][ch]>WAVE_THRESHOLD[band][ch]);
    // 閾値との上下関係がis_activeと同じなら普通なのでパス
    if(current_active_state==is_active[band][ch]) continue;
    // ここから閾値との上下関係が予想と違う時
    if(current_active_state!=song.isPlaying()){ // 再生状態とactive_stateが一致していないときは応答待ち中
      (current_active_state?rt_in:rt_out)[band][ch][loop_counter]=millis()-play_state_changed_at;
      is_active[band][ch]=current_active_state;
    } else { // この場合は応答待ちでないので偽陽性/偽陰性
      (current_active_state?n_false_positive:n_false_negative)[band][ch][loop_counter]++;
    }
  }

  pointer[band] = (pointer[band] + 1) % BUFFER_SIZE;
}
