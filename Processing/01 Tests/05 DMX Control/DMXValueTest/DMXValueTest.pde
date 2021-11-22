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
int universeSize = 64;
int DMXPRO_BAUDRATE=9600;

Handle[] handles;

void setup() {
  size(275, 800);
  printArray(Serial.list());
  int num = 8;
  handles = new Handle[num];
  int hsize = 10;
  for (int i = 0; i < handles.length; i++) {
    handles[i] = new Handle(i, 10, 30+i*30, 0, 10, 255, handles);
  }
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
}

void mouseReleased()  {
  for (int i = 0; i < handles.length; i++) {
    handles[i].releaseEvent();
  }
}

class Handle {
  
  int x, y;
  int boxx, boxy;
  int stretch;
  int size;
  int mywidth;
  int id;
  boolean over;
  boolean press;
  boolean locked = false;
  boolean otherslocked = false;
  Handle[] others;
  
  Handle(int index, int ix, int iy, int il, int is, int iw, Handle[] o) {
    id = index;
    x = ix;
    y = iy;
    stretch = il;
    size = is;
    mywidth = iw;
    boxx = x+stretch - size/2;
    boxy = y - size/2;
    others = o;
  }
  
  void update() {
    boxx = x+stretch;
    boxy = y - size/2;
    
    for (int i=0; i<others.length; i++) {
      if (others[i].locked == true) {
        otherslocked = true;
        break;
      } else {
        otherslocked = false;
      }  
    }
    
    if (otherslocked == false) {
      overEvent();
      pressEvent();
    }
    
    if (press) {
      stretch = lock(mouseX-size/2-x, 0, mywidth-size);
      dmxOutput.set(id+1,stretch);
    }
  }
  
  void overEvent() {
    if (overRect(boxx, boxy, size, size)) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void pressEvent() {
    if (over && mousePressed || locked) {
      press = true;
      locked = true;
    } else {
      press = false;
    }
  }
  
  void releaseEvent() {
    locked = false;
  }
  
  void display() {
    fill(255);
    stroke(0);
    rect(x, boxy, mywidth, size);
    fill(0);
    stroke(0);
    rect(x, boxy, stretch, size);
    fill(255);
    stroke(0);
    rect(boxx, boxy, size, size);
    if (over || press) {
      line(boxx, boxy, boxx+size, boxy+size);
      line(boxx, boxy+size, boxx+size, boxy);
    }

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