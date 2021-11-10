import processing.sound.*;
SoundFile soundfile;

Table a;

void setup() {
  size(10, 10);
  frameRate(2); //control time per cell 
  a = loadTable("AppleLogo.csv", "header");
  soundfile = new SoundFile(this, "endroll.wav");
}

int i = 0;
int j = 0;

void draw(){
  //make noise when 0 -> 1
  if ((j!=0)&&(a.getInt(i,j-1) == 0)&&(a.getInt(i,j) == 1)){
    soundfile.play();
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
