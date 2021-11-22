import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;

int universeSize = 511;
byte[] dmxData = new byte[512];
byte[] swData = new byte[512];

float position = 0;

int maxBrightness = 165;

String schwankhalleLichtIP = "10.0.0.68"; // glaube ich
String schwankhalleLicht2IP = "10.92.190.194"; // glaube ich
String schwankhalleLicht3IP = "169.254.54.45"; // glaube ich

void setup() {
  size(275, 300);

  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  //artnet = new ArtNetClient(new ArtNetBuffer(), 8000, 8000);
  artnet.start();
  surface.setLocation(0, 0);

   
}

void draw() {
  background(153);
  for (int i = 0; i <= universeSize; i++) {
    //float p = position + i * map(255, 0, 255, 0, PI/2);
    float val = (exp(sin(millis()/2000.0*(PI/2))) - 0.36787944)*108.0;
    val = limiter(val);
    background(val);
    //dmxOutput.set(i,(int) max(0, map(sin(p), -1, 1, -(128-50)*10, 50*2)));
    swData[i] = (byte)val;
    /*
    swData[0] = (byte)val;
    swData[1] = (byte)val;
    swData[337] = (byte)val;
    swData[338] = (byte)val;
    swData[339] = (byte)val;
    swData[340] = (byte)val;
    swData[341] = (byte)val;
    swData[342] = (byte)val;
    */
    

  }
  
  //position += 50 / 255.0 / Math.PI;

  // send dmx to localhost
  for(int i = 0; i<20; i++) {
    
    //artnet.unicastDmx("2.12.4.156", 0, i, dmxData);
    //artnet.unicastDmx("2.161.30.223", 0, i, dmxData);
    //artnet.unicastDmx("2.12.4.124", 0, i, dmxData);
    //artnet.unicastDmx(schwankhalleLichtIP, 0, i, swData);
    artnet.unicastDmx(schwankhalleLichtIP, 0, i, swData);
    
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
