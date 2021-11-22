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



void setup() {
  size(275, 300);
  printArray(Serial.list());
  int num = 4;
  
  int hsize = 10;
  //for (int i = 0; i < handles.length; i++) {
  
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
  
  
  
  for (int i=1; i<=universeSize; i++) {
    float p = position + i * map(255, 0, 255, 0, PI/2);
    float val = (exp(sin(millis()/2000.0*(PI/2))) - 0.36787944)*108.0;
    background(val);
    //dmxOutput.set(i,(int) max(0, map(sin(p), -1, 1, -(128-50)*10, 50*2)));
    dmxOutput.set(i, (int)val);

  }
  
  position += 50 / 255.0 / Math.PI;
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
