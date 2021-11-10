import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;

int universeSize = 511;
byte[] dmxData = new byte[512];

float position = 0;

int maxBrightness = 165;

void setup() {
  size(275, 300);

  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();
  surface.setLocation(0, 0);

   
}

void draw() {
  background(153);
  for (int i = 0; i <= universeSize; i++) {
    float p = position + i * map(255, 0, 255, 0, PI/2);
    float val = (exp(sin(millis()/2000.0*(PI/2))) - 0.36787944)*108.0;
    val = limiter(val);
    background(val);
    //dmxOutput.set(i,(int) max(0, map(sin(p), -1, 1, -(128-50)*10, 50*2)));
    dmxData[i] = (byte)i;

  }
  
  position += 50 / 255.0 / Math.PI;

  // send dmx to localhost
  for(int i = 0; i<4; i++) {
    
    //artnet.unicastDmx("2.12.4.156", 0, i, dmxData);
    //artnet.unicastDmx("2.161.30.223", 0, i, dmxData);
    artnet.unicastDmx("2.12.4.124", 0, i, dmxData);
    //artnet.unicastDmx("2.0.0.24", 0, i, dmxData);
    
    //artnet.unicastDmx("2.12.4.156", 0, i, dmxData);
  //artnet.broadcastDmx(0, i, dmxData);
  //artnet.broadcastDmx(0, 1, dmxData);
  
  
  }
  
  //artnet.unicastDmx("2.0.0.180", 0, 0, dmxData);
}

int limiter(int val) {
  return (int)map(val, 0, 255, 0, maxBrightness);
}

int limiter(float val) {
  return (int)map(val, 0, 255, 0, maxBrightness);
}
