// imports
import controlP5.*;
import ch.bildspur.artnet.*;

// Objects
JSONParser generalSettings;
JSONParser timelineSettings;
Timeline timeline;
ControlP5 cp5;

// booleans
boolean mediaShow = false;
boolean online = true;

// colors
color white = color(255);
color black = color(0);
color gray = color(125);

// timings
long mediaShowOffset = 0;

// strings
String scrollIP = "2.0.0.2";
String curtainsIP = "2.0.0.3";
String cornersIP = "2.0.0.4";
// fans are just part of a teensy
// turntables are just part of a teensy as well
String ledsIP = "2.12.4.132"; // glaube ich

byte[] scrollData = new byte[4];
byte[] curtainsData = new byte[12];
byte[] cornersData = new byte[20];
byte[][] ledsData = new byte[4][240]; // 4 universe each 240 LEDs

// some control
void keyPressed() {
  if (key == CODED) {
    if(keyCode == LEFT) {
    } else if(keyCode == RIGHT) {
    } else if(keyCode == UP) {
    } else if(keyCode == DOWN) {
    }
  } else {
    if (key == 'e' || key == 'E' ) {
    }
  }
}

void initSetup() {
  timelineSettings = new JSONParser("../settings/timeline.json");
  timeline = new Timeline();
  timeline.init();
  loadChunks();
  
  initCP5();
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

    //nt aniID, int routeID, String anistyle) {
    timeline.addChunk((timecode-mediaShowOffset), duration, comment, module);
    if(module.equals("scroll")) {
      //println("add parameter to last chunk");
      int ena = timelineSettings.getData().getJSONObject(i).getInt("enable");
      int vel = timelineSettings.getData().getJSONObject(i).getInt("velocity");
      int dir = timelineSettings.getData().getJSONObject(i).getInt("dir");
      timeline.getChunk(i).setScrollParameters(ena, vel, dir);
      //if(parameter3 >= 0) timeline.getChunk(i).getAnimator().setFaderParameters(timelineSettings.getData().getJSONObject(i).getInt("parameter1"), timelineSettings.getData().getJSONObject(i).getInt("parameter2") + (int)random(0, parameter3));
      //else timeline.getChunk(i).getAnimator().setFaderParameters(timelineSettings.getData().getJSONObject(i).getInt("parameter1"), timelineSettings.getData().getJSONObject(i).getInt("parameter2"));
    }
  }
  
}
