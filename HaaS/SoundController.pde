// 二値行列を基に音を出力するクラス
import processing.sound.*;


class SoundController {
  private PApplet parent;
  SoundFile soundfile;
  Table a;
  int i = 0;
  int j = 0;
  int count = 0;
  SoundController(PApplet parent){
    this.parent=parent; // メインファイルでthisが指す対象を持っていないと音声を読み込めない
    a = parent.loadTable("AppleLogo.csv", "header");
    soundfile = new SoundFile(parent, "endroll.wav");
  }
  public void draw(){ // この関数をメインファイルのdraw関数で呼び出す想定
    // Processing特有の変数や関数を使いたい時は、`parent.***`という形で呼び出す
    count += 1;
    
    if(count != 30){
      return;
    }
    count = 0;
    
    //make noise when 0 -> 1
    if ((j!=0)&&(a.getInt(i,j-1) == 0)&&(a.getInt(i,j) == 1)){
      soundfile.loop();
    }
    
    //stop noise when 1 -> 0
    if ((j+1!=48)&&(a.getInt(i,j) == 1)&&(a.getInt(i,j+1) == 0)){
      soundfile.stop();
    }
    
    //loop 
    j += 1;  
    if (j == a.getColumnCount()){
      j = 0;
      i += 1;
    }
    if (i == a.getRowCount()){
      noLoop();
    }
  }
}
