/**
 * Handles. 
 * 
 * Click and drag the white boxes to change their position. 
 */

import dmxP512.*;
import processing.serial.*;

DmxP512 dmxOutput;

boolean LANBOX=false;
String LANBOX_IP="192.168.1.77";

boolean DMXPRO=true;

String DMXPRO_PORT = "/dev/tty.usbserial-EN216471";
int universeSize = 40;
int DMXPRO_BAUDRATE=9600;

float position = 0;

Handle[] handles;

void setup() {
  size(275, 300);
  printArray(Serial.list());
  int num = 4;
  handles = new Handle[num];
  int hsize = 10;
  //for (int i = 0; i < handles.length; i++) {
  handles[0] = new Handle(0, 10, 30+0*30, 10, 10, 255, handles);
  handles[1] = new Handle(1, 10, 30+1*30, 200, 10, 255, handles);
  handles[2] = new Handle(2, 10, 30+2*30, 50, 10, 128, handles);
  handles[2].invert = true;
  handles[3] = new Handle(3, 10+127, 30+2*30, 50, 10, 127, handles);
  //}
  setupDMX();
}

void setupDMX() {
  dmxOutput=new DmxP512(this,universeSize,false);
  
  if(LANBOX){
    dmxOutput.setupLanbox(LANBOX_IP);
  }
  
  if(DMXPRO){
    dmxOutput.setupDmxPro(DMXPRO_PORT,DMXPRO_BAUDRATE);
  }
}
void draw() {
  background(153);
  
  for (int i = 0; i < handles.length; i++) {
    handles[i].update();
    handles[i].display();
  }
  
  for (int i=1; i<=universeSize; i++) {
    float p = position + i * map(handles[1].stretch, 0, 255, 0, PI/2);
    dmxOutput.set(i,(int) max(0, map(sin(p), -1, 1, -(128-handles[2].stretch)*10, handles[3].stretch*2)));
  }
  
  position += handles[0].stretch / 255.0 / Math.PI;
}

void mouseReleased()  {
  for (int i = 0; i < handles.length; i++) {
    handles[i].releaseEvent();
  }
}



boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

int lock(int val, int minv, int maxv) { 
  return  min(max(val, minv), maxv); 
} 
