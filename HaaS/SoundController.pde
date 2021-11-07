// 二値行列を基に音を出力するクラス

class SoundController {
  private PApplet parent;
  SoundController(PApplet parent){
    this.parent=parent; // メインファイルでthisが指す対象を持っていないと音声を読み込めない
  }
  public void setup(){ // この関数をメインファイルのsetup関数で呼び出す想定
    // NOTE: 画像の読み込みや前処理が必要ならここで実装
    // Processing特有の変数や関数を使いたい時は、`parent.***`という形で呼び出す
  }
  public void draw(){ // この関数をメインファイルのdraw関数で呼び出す想定
    // Processing特有の変数や関数を使いたい時は、`parent.***`という形で呼び出す
  }
}