/**
 * Handles. 
 * 
 * Click and drag the white boxes to change their position. 
 */

import ch.bildspur.artnet.*;

ArtNetClient artnet;

int universeSize = 511;
byte[] dmxData1 = new byte[512];
byte[] dmxData2 = new byte[512];

float position = 0;

Handle[] handles;

void setup() {
  size(275, 300);
  
  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();

  int num = 4;
  handles = new Handle[num];
  
  //for (int i = 0; i < handles.length; i++) {
  handles[0] = new Handle(0, 10, 30+0*30, 2, 10, 255, handles);
  handles[1] = new Handle(1, 10, 30+1*30, 2, 10, 255, handles);
  handles[2] = new Handle(2, 10, 30+2*30, 50, 10, 128, handles);
  handles[2].invert = true;
  handles[3] = new Handle(3, 10+127, 30+2*30, 10, 10, 127, handles);
  //}
  
}


void draw() {
  background(153);
  
  for (int i = 0; i < handles.length; i++) {
    handles[i].update();
    handles[i].display();
  }
  
  for (int i=1; i<=universeSize; i++) {
    float p = position + i * map(handles[1].stretch, 0, 255, 0, PI/2);
    dmxData1[i] = (byte)(int) max(0, map(sin(p), -1, 1, -(128-handles[2].stretch)*10, handles[3].stretch*2));
    dmxData2[(int)map(i, 0, 512, 512, 0)] = (byte)(int) max(0, map(sin(p), -1, 1, -(128-handles[2].stretch)*10, handles[3].stretch*2));
    
  }
  position += handles[0].stretch / 255.0 / Math.PI;
 
    artnet.unicastDmx("2.12.4.124", 0, 0, dmxData1);
    artnet.unicastDmx("2.12.4.124", 0, 1, dmxData2);
       
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
