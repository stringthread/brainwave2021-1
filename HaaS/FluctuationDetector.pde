// 閾値を超えた脳波変動を検知するクラス
// 実装の簡便性のため、脳波変動による2値状態の変動まで計算して、その時点での2値状態を保持する

import oscP5.OscMessage;

class FluctuationDetector {
  private boolean isOverThreshold, wasOverThreshold; // 現在と1ステップ前に閾値以上だったかを表す
  private boolean _isActive, _isDetecting;
  public boolean isActive(){ return _isActive; } // このメソッドを呼び出して状態を取得する
  public void restart(){
    _isActive=true;
    _isDetecting=true;
  }
  public void stopDetection(){_isDetecting=false;}

  private BrainWaveStorage storage;
  FluctuationDetector(BrainWaveStorage storage){
    this.storage=storage;
  }

  public void draw(){
    if(_isDetecting){
      wasOverThreshold=isOverThreshold;
      isOverThreshold=storage.fromAverageBuffer()<0.3f;
      if(isOverThreshold==true&&wasOverThreshold==false){
        _isActive=!_isActive; // 閾値との上下関係が変化したら状態をトグル
        _isDetecting=false;
      }
    }
  }
}
