// 閾値を超えた脳波変動を検知するクラス
// 実装の簡便性のため、脳波変動による2値状態の変動まで計算して、その時点での2値状態を保持する

import oscP5.OscMessage;

class FluctuationDetector {
  private boolean isOverThreshold, wasOverThreshold; // 現在と1ステップ前に閾値以上だったかを表す
  private boolean _isActive;
  public boolean isActive(){ return _isActive; } // このメソッドを呼び出して状態を取得する
  FluctuationDetector(){}

  final int AVERAGE_RANGE=60; // 6秒間で移動平均
  final int THRESHOLD_TIME_LATENCY=50; // 閾値計算の基準とする時間差 [/Frames]
  final float THRESHOLD_DIFFERENCE=0.3; // 下げ幅の閾値
  final int DETECTED_CH=0; // 計測対象のチャンネル
  float[] buffer = new float[AVERAGE_RANGE]; // 単一の脳波値
  float[] average_buffer=new float[AVERAGE_RANGE]; // 各時点での平均脳波値
  int pointer = 0;

  private float average(){
    float result=0;
    int current_pointer;
    for(int i=0;i<AVERAGE_RANGE;i++){
      current_pointer=(pointer-i+AVERAGE_RANGE)%AVERAGE_RANGE; // 負にならないようAVERAGE_RANGEを足している
      result+=buffer[current_pointer];
    }
    return result/AVERAGE_RANGE;
  }
  public void oscEvent(OscMessage msg){ // これをメインファイルのoscEventで呼び出して値を更新する
    if(msg.checkAddrPattern("/muse/elements/alpha_absolute")){
      buffer[pointer] = msg.get(DETECTED_CH).floatValue();
      average_buffer[pointer] = average();
      int compared_pointer=(pointer-THRESHOLD_TIME_LATENCY+AVERAGE_RANGE)%AVERAGE_RANGE;
      wasOverThreshold=isOverThreshold;
      isOverThreshold=average_buffer[pointer]<average_buffer[compared_pointer]-THRESHOLD_DIFFERENCE;
      if(isOverThreshold!=wasOverThreshold) _isActive=!_isActive; // 閾値との上下関係が変化したら状態をトグル
      pointer = (pointer + 1) % AVERAGE_RANGE;
    }
  }
}