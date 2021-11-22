// imports
import controlP5.*;
import ch.bildspur.artnet.*;
import processing.sound.*;

// Objects
JSONParser generalSettings;
JSONParser timelineSettings;
Timeline timeline;
ControlP5 cp5;
SoundFile soundfile;
PFont font;


// booleans
boolean mediaShow = false;
boolean online = true;
boolean playAudio = false; // use processing sound library instead of chang.
boolean scrollOnline;
boolean blackOffLEDs = false;

// colors
color white = color(255);
color black = color(0);
color gray = color(125);
color blue = color(0, 0, 255);

// timings
long mediaShowOffset = 0;


// strings
String scrollIP = "2.0.0.2";
String curtainsIP = "2.0.0.3";
String cornersIP = "2.0.0.4";
// fans are just part of a teensy
// turntables are just part of a teensy as well
String ledsIP = "2.12.4.124"; // glaube ich

// data
byte[] scrollData = new byte[3];
byte[] curtainsData = new byte[9];
byte[] cornersData = new byte[15];
byte[][] ledsData = new byte[4][40*6]; // 4 universe each 240 LEDs

// debug outputs
StringList currentChunk;
StringList scrollOutput;
StringList cornersOutput;
StringList curtainsOutput;

// LEDs
int universeSize = 40*6;
float breathePosition = 0;
int maxBrightness = 165;

// some control
void keyPressed() {
  if (key == CODED) {
    if(keyCode == LEFT) {
    } else if(keyCode == RIGHT) {
    } else if(keyCode == UP) {
    } else if(keyCode == DOWN) {
    }
  } else {
    if (key == ' ') {
      //println("stop");
    } else if (key == 'e' || key == 'E' ) {
    }
  }
}

void initSetup() {
  timelineSettings = new JSONParser("../settings/211118_timeline.json");
  timeline = new Timeline();
  timeline.init();
  loadChunks();
  
  font = loadFont("Theinhardt-Medium-16.vlw");
  textFont(font, 16);
  
  initCP5();
  
  soundfile = new SoundFile(this, "htwwprtstnov13._mstr.wav");
  
  initOutputs();
}

void initOutputs() {
  currentChunk = new StringList();
  scrollOutput = new StringList();
  curtainsOutput = new StringList();
  cornersOutput = new StringList();
}

void showOutputs() {
  push();
  fill(255);
  int lineHeight = 16;
  for(int i = 0; i<currentChunk.size(); i++) {
    text(currentChunk.get(i), 10, 20 + (lineHeight*i));
  }
  
  for(int i = 0; i<curtainsOutput.size(); i++) {
    text(curtainsOutput.get(i), 10, 100 + (lineHeight*i));
  }
  
  for(int i = 0; i<cornersOutput.size(); i++) {
    text(cornersOutput.get(i), 10, 200 + (lineHeight*i));
  }
  pop();
}

void drawCube() {
}

void loadChunks() {
  
  println("loading chunks into timeliner=" + timelineSettings.getData().size());
  for(int i = 0; i<timelineSettings.getData().size(); i++) {
    //println(timelineSettings.getData().getJSONObject(i));
    int minute = timelineSettings.getData().getJSONObject(i).getInt("minute");
    int second = timelineSettings.getData().getJSONObject(i).getInt("second");
    int milliseconds = timelineSettings.getData().getJSONObject(i).getInt("milliseconds");
    int duration = timelineSettings.getData().getJSONObject(i).getInt("duration");
    String comment = timelineSettings.getData().getJSONObject(i).getString("comment");
    String module = timelineSettings.getData().getJSONObject(i).getString("module"); 
    
    int timecode;
    if(minute > 0 || second > 0) timecode = (minute*1000*60) + (second*1000) + milliseconds;
    else timecode = milliseconds;
    
    mediaShowOffset = (startMinute*1000*60) + (startSecond*1000);

    timeline.addChunk((timecode-mediaShowOffset), duration, comment, module);
    
    if(module.equals("scroll")) {
      //println("add parameter to last chunk");
      int ena = timelineSettings.getData().getJSONObject(i).getInt("enable");
      int vel = timelineSettings.getData().getJSONObject(i).getInt("velocity");
      String dir = timelineSettings.getData().getJSONObject(i).getString("dir");
      timeline.getChunk(i).setScrollParameters(vel, dir);
      
    } else if(module.equals("curtains")) {
      int motorNr = timelineSettings.getData().getJSONObject(i).getInt("motorNr");
      int vel = timelineSettings.getData().getJSONObject(i).getInt("velocity");
      String dir = timelineSettings.getData().getJSONObject(i).getString("dir");
      timeline.getChunk(i).setCurtainParameters(motorNr, vel, dir);
      
    } else if(module.equals("corners")) {
      int motorNr = timelineSettings.getData().getJSONObject(i).getInt("motorNr");
      int vel = timelineSettings.getData().getJSONObject(i).getInt("velocity");
      String dir = timelineSettings.getData().getJSONObject(i).getString("dir");
      timeline.getChunk(i).setCornersParameters(motorNr, vel, dir);
      
    } else if(module.equals("fans")) {
      boolean ena = timelineSettings.getData().getJSONObject(i).getBoolean("enable");
      timeline.getChunk(i).setFanParameters(ena);
      
    } else if(module.equals("turntables")) {
      int motorNr = timelineSettings.getData().getJSONObject(i).getInt("motorNr");
      boolean ena = timelineSettings.getData().getJSONObject(i).getBoolean("enable");
      int vel = timelineSettings.getData().getJSONObject(i).getInt("velocity");
      timeline.getChunk(i).setTurntableParameters(motorNr, ena, vel);
      
    } else if(module.equals("leds")) {
    } else if(module.equals("laptop")) {
    } else if(module.equals("curtains_enable")) {
      boolean ena = timelineSettings.getData().getJSONObject(i).getBoolean("enable");
      timeline.getChunk(i).setCurtainsEnable(ena);
    }
  }
  
}

void breatheLEDs() {
  
  for(int u = 0; u<2; u++) {
    for (int i = 0; i < universeSize; i++) {
      float val = (exp(sin(millis()/2000.0*(PI/8))) - 0.36787944)*108.0;
      val = limiter(val);
      ledsData[u][i] = (byte)val;
    }
  }
}

void sendLEDs() {
  for(int u = 0; u<2; u++) artnet.unicastDmx("2.12.4.124", 0, u, ledsData[u]);
}

int limiter(int val) {
  return (int)map(val, 0, 255, 0, maxBrightness);
}

int limiter(float val) {
  return (int)map(val, 0, 255, 0, maxBrightness);
}

void updateGUI() {
  labelFPS.setText("FPS / "+ round(frameRate));
}

void playAudioFromStart() {
  if(soundfile != null) {
    soundfile.stop();
    soundfile.jump(0);
    soundfile.play();
  }
}

void printNicely(String s, byte[] data) {
  print(s + "(");
  for(int i = 0; i<data.length; i++) {
    if(i+1 != data.length) print(data[i] + ", "); 
    else print(data[i]);
  }
  println(")");
}

void stopAllMotors() {
  byte[] scrollData = new byte[3];
  byte[] curtainsData = new byte[9];
  byte[] cornersData = new byte[15];
  artnet.unicastDmx(scrollIP, 0, 0, scrollData);
  artnet.unicastDmx(curtainsIP, 0, 0, curtainsData);
  artnet.unicastDmx(cornersIP, 0, 0, cornersData);
}
