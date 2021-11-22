

/**
 * Handles. 
 * 
 * Click and drag the white boxes to change their position. 
 */

import dmxP512.*;
import processing.serial.*;
import controlP5.*;

DmxP512 dmxOutput;
ControlP5 cp5;


boolean LANBOX=false;
String LANBOX_IP="192.168.1.77";

boolean DMXPRO=true;

String DMXPRO_PORT = "/dev/tty.usbserial-EN216471";
int universeSize = 40;
int DMXPRO_BAUDRATE=9600;

float position = 0;

int sliderValue = 100;


void setup() {
  size(275, 300);
  printArray(Serial.list());
  setupDMX();
    cp5 = new ControlP5(this);
    
    cp5.addSlider("sliderValue")
     .setRange(0,255)
     .setValue(120)
     .setPosition(65,height/2)
     .setSize(100,10)
     .setLabel("BRIGHTNESS")
     .setColorActive(color(155))
     .setColorForeground(color(0))
  
     .setColorBackground(color(255))
  
     ;

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
  background(sliderValue);
  pushStyle();
  fill(0);
    rect(62, (height/2)-3, 155, 15);
  popStyle();
  
  
  for (int i=1; i<=universeSize; i++) {
    //float p = position + i * map(255, 0, 255, 0, PI/2);
    //float val = (exp(sin(millis()/2000.0*(PI/2))) - 0.36787944)*108.0;

    dmxOutput.set(i, sliderValue);

  }
  
  //position += 50 / 255.0 / Math.PI;
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
