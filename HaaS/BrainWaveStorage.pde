// 脳波情報を一元管理するクラス

import oscP5.*;

class BrainWaveStorage {
  public static final int BUFFER_SIZE=220;

  private float[] buffer=new float[BUFFER_SIZE];
  public float fromBuffer(int i){ return buffer[toPointer(i)]; }
  public float fromBuffer(){ return buffer[pointer]; }

  private float[] averageBuffer=new float[BUFFER_SIZE];
  public float fromAverageBuffer(int i){ return averageBuffer[toPointer(i)]; }
  public float fromAverageBuffer(){ return averageBuffer[pointer]; }

  private int pointer=0;
  public int getPointer(){ return pointer; }

  private int toPointer(int i){ return (i+BUFFER_SIZE)%BUFFER_SIZE; } // BUFFERをCyclicになめたときのi番目の要素へのindex

  BrainWaveStorage(){}

  private final int DETECTED_CH=0;
  private final int AVERAGE_RANGE=60; // 6秒間で移動平均

  private float average(){
    float result=0;
    int currentPointer;
    for(int i=0;i<AVERAGE_RANGE;i++){
      currentPointer=toPointer(pointer-i);
      result+=buffer[currentPointer];
    }
    return result/AVERAGE_RANGE;
  }

  public void oscEvent(OscMessage msg){ // これをメインファイルのoscEventで呼び出す
    float data;
    if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
      pointer=(pointer + 1) % BUFFER_SIZE;
      buffer[pointer]=msg.get(DETECTED_CH).floatValue();
      averageBuffer[pointer]=average();
    }
  }
}
