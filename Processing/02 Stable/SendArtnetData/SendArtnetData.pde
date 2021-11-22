/*
timer label
also from custom start time
*/

import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;
ControlP5 cp5;

int startMin = 4;
int startSec = 6;
boolean timerRun = false;

// general variables
PFont font;
boolean[] online = {false, false, false};
//boolean[] online = {false, false, false};
boolean cp5init = false;

// runtime variables
byte[] scrollData = new byte[3];
byte[] curtainsData = new byte[9];
byte[] cornersData = new byte[15];
byte[][] ledsData = new byte[4][240]; // 4 universe each 240 LEDs

String scrollIP = "2.0.0.2";
String curtainsIP = "2.0.0.3";
String cornersIP = "2.0.0.4";
// fans are just part of a teensy
// turntables are just part of a teensy as well
String ledsIP = "2.12.4.132"; // glaube ich

boolean scrollEnabled = true;
int sliderScrollSpeed = 0;
boolean scrollDir = false;

boolean curtainsEnabled = true;
int[] curtainSpeeds = {0, 0, 0, 0};
boolean[] curtainDirs = {true, true, true, true};

boolean cornersEnabled = true;
int[] cornerSpeeds = {0, 0, 0, 0};
boolean[] cornerDirs = {true, true, true, true};

boolean turntablesEnabled = true;
int[] turntableSpeeds = {0, 0, 0};

boolean fansEnable = false;
boolean desktopLED = false;

// artnet leds
boolean ledsToggle = false;
int maxBrightness = 180;
boolean ledsBreathe = false;
boolean ledsRun = false;

void setup() {
  size(800, 600, P2D);
  surface.setLocation(0, 0);
  frameRate(60);
  font = loadFont("Theinhardt-Medium-16.vlw");
  textFont(font);
  textSize(16);

  artnet = new ArtNetClient(null);
  artnet.start();
  
  cp5init();
  cp5init = true;
}

void draw() {
  background(0);
  fill(255);
  rect(5, 4, 130, 20);
  fill(0);
  text("Artnet Controller", 10, 20);
  
  push();
  translate(0, 0);
  fill(255);
  text("Scroll IP: " + scrollIP, 10, 40);
  text("Enabled: " + (scrollEnabled?"yes":"no"), 30, 60);
  text("Speed: " + sliderScrollSpeed, 30, 80);
  text("Direction: " + (scrollDir?"down":"up"), 30, 100);
  pop();
  
  // CURTAINS
  push();
  translate(0, 120);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("1", 10, 60);
  fill(255);
  text("Curtains IP: " + curtainsIP, 10, 40);
  // ------> text("Enabled: " + (curtainEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[0], 30, 60);
  text("Direction: " + (curtainDirs[0]?"opening":"closing"), 30, 80);
  pop();
  
  push();
  translate(0, 200);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("2", 10, 60);
  fill(255);
  //text("Enabled: " + (curtainEnables[1]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[1], 30, 60);
  text("Direction: " + (curtainDirs[1]?"opening":"closingn"), 30, 80);
  pop();
  
  push();
  translate(0, 280);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("3", 10, 60);
  fill(255);
  //text("Enabled: " + (curtainEnables[2]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[2], 30, 60);
  text("Direction: " + (curtainDirs[2]?"opening":"closing"), 30, 80);
  pop();
  
  push();
  translate(0, 360);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("4", 10, 60);
  fill(255);
  //text("Enabled: " + (curtainEnables[3]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[3], 30, 60);
  text("Direction: " + (curtainDirs[3]?"opening":"closing"), 30, 80);
  pop();
  
  // CORNERS
  push();
  translate(320, 0);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("1", 10, 60);
  fill(255);
  text("Corners IP: " + cornersIP, 10, 40);
  //text("Enabled: " + (cornerEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[0], 30, 60);
  text("Direction: " + (cornerDirs[0]?"up":"down"), 30, 80);
  pop();
  
  push();
  translate(320, 80);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("2", 10, 60);
  fill(255);
  //text("Enabled: " + (cornerEnables[1]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[1], 30, 60);
  text("Direction: " + (cornerDirs[1]?"up":"down"), 30, 80);
  pop();
  
  push();
  translate(320, 160);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("3", 10, 60);
  fill(255);
  //text("Enabled: " + (cornerEnables[2]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[2], 30, 60);
  text("Direction: " + (cornerDirs[2]?"up":"down"), 30, 80);
  pop();
  
  push();
  translate(320, 240);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("4", 10, 60);
  fill(255);
  //text("Enabled: " + (cornerEnables[3]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[3], 30, 60);
  text("Direction: " + (cornerDirs[3]?"up":"down"), 30, 80);
  pop();
  
  push();
  fill(255);
  translate(320, 330);
  text("Fans Enabled: " + (fansEnable?"yes":"no"), 10, 40);
  pop();
  
  push();
  translate(320, 370);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("1", 10, 60);
  fill(255);
  text("Turntables", 10, 40);
//  text("Enabled: " + (turntableEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + turntableSpeeds[0], 30, 70);
  pop();
  
  push();
  translate(320, 410);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("2", 10, 60);
  fill(255);
  //text("Enabled: " + (turntableEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + turntableSpeeds[1], 30, 60);
  pop();
  
  push();
  translate(320, 450);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("3", 10, 60);
  fill(255);
  //text("Enabled: " + (turntableEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + turntableSpeeds[2], 30, 60);
  pop();
  
  //
  
  // populate data :)
  scrollData[0] = (byte) (scrollEnabled?1:0);
  scrollData[1] = (byte) sliderScrollSpeed;
  scrollData[2] = (byte) (scrollDir?1:0);
  
  // CURTAINS
  //curtainsData[0] = (byte) (curtainEnables[0]?1:0);
  curtainsData[0] = (byte) curtainSpeeds[0];
  curtainsData[1] = (byte) (curtainDirs[0]?1:0);
  
  curtainsData[2] = (byte) curtainSpeeds[1];
  curtainsData[3] = (byte) (curtainDirs[1]?1:0);
  
  curtainsData[4] = (byte) curtainSpeeds[2];
  curtainsData[5] = (byte) (curtainDirs[2]?1:0);
  
  curtainsData[6] = (byte) curtainSpeeds[3];
  curtainsData[7] = (byte) (curtainDirs[3]?1:0);
  
  curtainsData[8] = (byte) (curtainsEnabled?1:0);
  
  
  // CORNERS
  //cornersData[0] = (byte) (cornerEnables[0]?1:0);
  cornersData[0] = (byte) cornerSpeeds[0];
  cornersData[1] = (byte) (cornerDirs[0]?1:0);
  cornersData[2] = (byte) cornerSpeeds[1];
  cornersData[3] = (byte) (cornerDirs[1]?1:0);
  cornersData[4] = (byte) cornerSpeeds[2];
  cornersData[5] = (byte) (cornerDirs[2]?1:0);
  cornersData[6] = (byte) cornerSpeeds[3];
  cornersData[7] = (byte) (cornerDirs[3]?1:0);
  cornersData[8] = (byte) (cornersEnabled?1:0);
  cornersData[9] = (byte) turntableSpeeds[0];
  cornersData[10] = (byte) turntableSpeeds[1];
  cornersData[11] = (byte) turntableSpeeds[2]; 
  cornersData[12] = (byte) (turntablesEnabled?1:0);
  cornersData[13] = (byte) (fansEnable?1:0);
  cornersData[14] = (byte) (desktopLED?1:0);
  

  
  if(online[0]) {
    try {
      artnet.unicastDmx(scrollIP, 0, 0, scrollData);
    }
    catch(Exception e) {
      println("scroll teensy down");
    }
  }
  
  if(online[1]) {
    try {
      artnet.unicastDmx(curtainsIP, 0, 0, curtainsData);
    }
    catch(Exception e) {
      println("curtains teensy down");
    }
    //printNicely("curtains", curtainsData);
  }
  
  if(online[2]) {
    try {
      artnet.unicastDmx(cornersIP, 0, 0, cornersData);
    }
    catch(Exception e) {
      println("corners teensy down");
    }
  }
  //printArray(curtainsData);
  
  
  // led animations
  ledsBreathe();
  
}

void printNicely(String s, byte[] data) {
  print(s + "(");
  for(int i = 0; i<data.length; i++) {
    if(i+1 != data.length) print(data[i] + ", "); 
    else print(data[i]);
  }
  println(")");
}
