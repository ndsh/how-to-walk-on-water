import ch.bildspur.artnet.*;
import controlP5.*;

ArtNetClient artnet;
ControlP5 cp5;

// general variables
PFont font;
boolean online = true;
boolean cp5init = false;

// runtime variables
byte[] scrollData = new byte[4];
byte[] curtainsData = new byte[12];
byte[] cornersData = new byte[20];
byte[][] ledsData = new byte[4][240]; // 4 universe each 240 LEDs

String scrollIP = "2.0.0.2";
String curtainsIP = "2.0.0.3";
String cornersIP = "2.0.0.4";
// fans are just part of a teensy
// turntables are just part of a teensy as well
String ledsIP = "2.12.4.132"; // glaube ich

boolean scrollEnabled = true;
int sliderScrollSpeed = 125;
boolean scrollDir = false;

boolean[] curtainEnables = {true, true, true, true};
int[] curtainSpeeds = {0, 0, 0, 0};
boolean[] curtainDirs = {true, true, true, true};

boolean[] cornerEnables = {true, true, true, true};
int[] cornerSpeeds = {0, 0, 0, 0};
boolean[] cornerDirs = {true, true, true, true};

boolean[] turntableEnables = {true, true, true, true};
int[] turntableSpeeds = {125, 125, 125, 125};

boolean fansEnable = false;
boolean desktopLED = false;

void setup() {
  size(600, 600, P2D);
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
  text("Direction: " + (scrollDir?"up":"down"), 30, 100);
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
  text("Enabled: " + (curtainEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[0], 30, 80);
  text("Direction: " + (curtainDirs[0]?"up":"down"), 30, 100);
  pop();
  
  push();
  translate(0, 200);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("2", 10, 60);
  fill(255);
  text("Enabled: " + (curtainEnables[1]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[1], 30, 80);
  text("Direction: " + (curtainDirs[1]?"up":"down"), 30, 100);
  pop();
  
  push();
  translate(0, 280);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("3", 10, 60);
  fill(255);
  text("Enabled: " + (curtainEnables[2]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[2], 30, 80);
  text("Direction: " + (curtainDirs[2]?"up":"down"), 30, 100);
  pop();
  
  push();
  translate(0, 360);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("4", 10, 60);
  fill(255);
  text("Enabled: " + (curtainEnables[3]?"yes":"no"), 30, 60);
  text("Speed: " + curtainSpeeds[3], 30, 80);
  text("Direction: " + (curtainDirs[3]?"up":"down"), 30, 100);
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
  text("Enabled: " + (cornerEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[0], 30, 80);
  text("Direction: " + (cornerDirs[0]?"up":"down"), 30, 100);
  pop();
  
  push();
  translate(320, 80);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("2", 10, 60);
  fill(255);
  text("Enabled: " + (cornerEnables[1]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[1], 30, 80);
  text("Direction: " + (cornerDirs[1]?"up":"down"), 30, 100);
  pop();
  
  push();
  translate(320, 160);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("3", 10, 60);
  fill(255);
  text("Enabled: " + (cornerEnables[2]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[2], 30, 80);
  text("Direction: " + (cornerDirs[2]?"up":"down"), 30, 100);
  pop();
  
  push();
  translate(320, 240);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("4", 10, 60);
  fill(255);
  text("Enabled: " + (cornerEnables[3]?"yes":"no"), 30, 60);
  text("Speed: " + cornerSpeeds[3], 30, 80);
  text("Direction: " + (cornerDirs[3]?"up":"down"), 30, 100);
  pop();
  
  push();
  fill(255);
  translate(320, 330);
  text("Fans Enabled: " + (fansEnable?"yes":"no"), 10, 40);
  pop();
  
  push();
  translate(320, 360);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("1", 10, 60);
  fill(255);
  text("Turntables", 10, 40);
  text("Enabled: " + (turntableEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + turntableSpeeds[0], 30, 80);
  pop();
  
  push();
  translate(320, 400);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("2", 10, 60);
  fill(255);
  text("Enabled: " + (turntableEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + turntableSpeeds[0], 30, 80);
  pop();
  
  push();
  translate(320, 440);
  fill(255);
  ellipse(15, 55, 20, 20);
  fill(0);
  text("3", 10, 60);
  fill(255);
  text("Enabled: " + (turntableEnables[0]?"yes":"no"), 30, 60);
  text("Speed: " + turntableSpeeds[0], 30, 80);
  pop();
  
  //
  
  // populate data :)
  scrollData[0] = (byte) 1;
  scrollData[1] = (byte) sliderScrollSpeed;
  scrollData[2] = (byte) (scrollDir?1:0);
  
  // CURTAINS
  curtainsData[0] = (byte) (curtainEnables[0]?1:0);
  curtainsData[1] = (byte) curtainSpeeds[0];
  curtainsData[2] = (byte) (curtainDirs[0]?1:0);
  
  curtainsData[3] = (byte) (curtainEnables[1]?1:0);
  curtainsData[4] = (byte) curtainSpeeds[1];
  curtainsData[5] = (byte) (curtainDirs[1]?1:0);
  
  curtainsData[6] = (byte) (curtainEnables[2]?1:0);
  curtainsData[7] = (byte) curtainSpeeds[2];
  curtainsData[8] = (byte) (curtainDirs[2]?1:0);
  
  curtainsData[9] = (byte) (curtainEnables[3]?1:0);
  curtainsData[10] = (byte) curtainSpeeds[3];
  curtainsData[11] = (byte) (curtainDirs[3]?1:0);
  
  // CORNERS
  cornersData[0] = (byte) (cornerEnables[0]?1:0);
  cornersData[1] = (byte) cornerSpeeds[0];
  cornersData[2] = (byte) (cornerDirs[0]?1:0);
  
  cornersData[3] = (byte) (cornerEnables[1]?1:0);
  cornersData[4] = (byte) cornerSpeeds[1];
  cornersData[5] = (byte) (cornerDirs[1]?1:0);
  
  cornersData[6] = (byte) (cornerEnables[2]?1:0);
  cornersData[7] = (byte) cornerSpeeds[2];
  cornersData[8] = (byte) (cornerDirs[2]?1:0);
  
  cornersData[9] = (byte) (cornerEnables[3]?1:0);
  cornersData[10] = (byte) cornerSpeeds[3];
  cornersData[11] = (byte) (cornerDirs[3]?1:0);
  
  cornersData[12] = (byte) (fansEnable?1:0);
  
  cornersData[13] = (byte) (turntableEnables[0]?1:0);
  cornersData[14] = (byte) turntableSpeeds[0];
  
  cornersData[15] = (byte) (turntableEnables[1]?1:0);
  cornersData[16] = (byte) turntableSpeeds[1];
  
  cornersData[17] = (byte) (turntableEnables[2]?1:0);
  cornersData[18] = (byte) turntableSpeeds[2];
  
  cornersData[19] = (byte) (desktopLED?1:0);
  

  if(online) {
    artnet.unicastDmx(scrollIP, 0, 0, scrollData);
    artnet.unicastDmx(curtainsIP, 0, 0, curtainsData);
    artnet.unicastDmx(cornersIP, 0, 0, cornersData);
  }
}
