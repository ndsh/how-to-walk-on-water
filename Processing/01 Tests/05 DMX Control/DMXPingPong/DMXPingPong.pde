import dmxP512.*;
import processing.serial.*;
import controlP5.*;

DmxP512 dmxOutput;
ControlP5 cp5;

boolean LANBOX=false;
String LANBOX_IP="192.168.1.77";

boolean DMXPRO=true;

String DMXPRO_PORT = "/dev/tty.usbserial-EN216471";
int universeSize = 41;
int DMXPRO_BAUDRATE=9600;

int position = 0;
boolean direction = true;

long lastMillis = 0;
int intervalSlider = 1;


void setup() {
  size(275, 300);
  printArray(Serial.list());
  setupDMX();
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("intervalSlider")
   .setRange(0,200)
   .setValue(1)
   .setPosition(65,height/2)
   .setSize(100,10)
   .setLabel("SPEED")
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
  background(153);
  text(intervalSlider, 30, 30);
  
  if(millis() - lastMillis < intervalSlider) return;
  lastMillis = millis();
  
  println(position);
  if(direction) position++;
  else position--;
  
  if(position >= universeSize) {
    position = 40;
    direction = false;
  }
  else if(position < 0) {
    position = 0;
    direction = true;
  }

  for(int i = 0; i<universeSize; i++) {
    dmxOutput.set(i, 0);
  }
  dmxOutput.set(position, 255);
}
