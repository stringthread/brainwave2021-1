// 閾値を超えた脳波変動を検知するクラス
// 実装の簡便性のため、脳波変動による2値状態の変動まで計算して、その時点での2値状態を保持する

import oscP5.OscMessage;

class FluctuationDetector {
  private boolean isOverThreshold, wasOverThreshold; // 現在と1ステップ前に閾値以上だったかを表す
  private boolean _isActive;
  public boolean isActive(){ return _isActive; } // このメソッドを呼び出して状態を取得する

  private BrainWaveStorage storage;
  FluctuationDetector(BrainWaveStorage storage){
    this.storage=storage;
  }

  final int THRESHOLD_TIME_LATENCY=50; // 閾値計算の基準とする時間差 [/Frames]
  final float THRESHOLD_DIFFERENCE=0.3; // 下げ幅の閾値

  public void draw(){
    int compared_pointer=storage.getPointer()-THRESHOLD_TIME_LATENCY;
    wasOverThreshold=isOverThreshold;
    isOverThreshold=storage.fromAverageBuffer()<storage.fromAverageBuffer(compared_pointer)-THRESHOLD_DIFFERENCE;
    if(isOverThreshold!=wasOverThreshold) _isActive=!_isActive; // 閾値との上下関係が変化したら状態をトグル
  }
}