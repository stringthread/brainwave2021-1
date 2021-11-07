// 閾値を超えた脳波変動を検知するクラス
// 実装の簡便性のため、脳波変動による2値状態の変動まで計算して、その時点での2値状態を保持する

import oscP5.OscMessage;

class FluctuationDetector {
  private boolean isOverThreshold, wasOverThreshold; // 現在と1ステップ前に閾値以上だったかを表す
  private boolean _isActive;
  public boolean isActive(){ return _isActive; } // このメソッドを呼び出して状態を取得する
  private void setIsActive(boolean value){ _isActive=value; }
  FluctuationDetector(){}
  void oscEvent(OscMessage msg){ // これをメインファイルのoscEventで呼び出して値を更新する
    // TODO: これから_isActiveの更新処理を実装する
  }
}