// ウィンドウを適切な位置に描画させるクラス
// 実際には、継承してdrawContentを実装したクラスを用いる

abstract class BaseWindow {
  protected PApplet parent;
  protected PGraphics content;
  abstract protected void drawContent(PGraphics g); // contentに描画する処理
  public int x, y, w, h; // ウィンドウコンテンツの左上位置と大きさ
  private int outer_x, outer_y, outer_w, outer_h; // ウィンドウ自体の左上位置と大きさ
  private final int PADDING=40, CORNER_RADIUS=12;
  BaseWindow(PApplet parent, int x, int y, int w, int h) {
    this.parent=parent;
    outer_x=x; outer_y=y; outer_w=w; outer_h=h;
    this.x=outer_x+PADDING;
    this.y=outer_y+PADDING;
    this.w=outer_w-PADDING*2;
    this.h=outer_h-PADDING*2;
    content=createGraphics(this.w,this.h);
  }
  void draw() { // この関数をメインファイルのdraw関数で呼び出す想定
    content.beginDraw();
    drawContent(content);
    content.endDraw();
    parent.strokeWeight(2);
    parent.stroke(0);
    parent.fill(245);
    parent.rect(outer_x,outer_y,outer_w,outer_h,CORNER_RADIUS);
    parent.image(content, x, y);
  }
}
