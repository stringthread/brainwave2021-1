// ウィンドウを適切な位置に描画させるクラス
// 実際には、継承してdrawContentを実装したクラスを用いる

abstract class BaseWindow {
  private PApplet parent;
  private PGraphics content;
  private void drawContent(PGraphics); // contentに描画する処理
  public int x, y, w, h; // ウィンドウコンテンツの左上位置と大きさ
  Window(PApplet parent, int x, int y, int w, int h) {
    this.parent=parent;
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    content=createGraphics(this.w,this.h);
  }
  void draw() { // この関数をメインファイルのdraw関数で呼び出す想定
    content.beginDraw();
    drawContent(content);
    content.endDraw();
    parent.image(content, x, y);
    // TODO: ここにタイトルバー等の描画処理を足す
  }
}