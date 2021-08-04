import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
Serial myPort;

int motorState = 0;
boolean setupDone = false;
String val = "";

void setup() {
  size(600, 600);
  surface.setLocation(0, 0);
  
  cp5 = new ControlP5(this);
  
  cp5.addButton("up")
  .setValue(0)
  .setPosition(0,0)
  .setSize(width,200)
  .setLabel("UP")
  ;
  
  cp5.addButton("yield")
  .setValue(0)
  .setPosition(0,200)
  .setSize(width,200)
  .setLabel("STOP")
  ;
  
  cp5.addButton("down")
  .setValue(0)
  .setPosition(0,400)
  .setSize(width,200)
  .setLabel("DOWN")
  ;
  
  String pattern = "/dev/tty.usbmodem"; // mac only
  int port = 0;
  println("Listing available serial ports.");
  for(int i = 0; i<Serial.list().length; i++) {
    println("["+ i +"] \"" + Serial.list()[i] +"\"");
    if(Serial.list()[i].substring(0, pattern.length()).equals(pattern)) {
      println("Found port=" + i);
      port = i;
      break;
    }
  }
  String portName = Serial.list()[port]; //change the 0 to a 1 or 2 etc. to match your port
  println("Talking to= "+ portName);
  myPort = new Serial(this, portName, 9600);
  setupDone = true;
  println();
}

void draw() {
  background(0);
  /*
  if(motorState == 1)
  else if(motorState == 0)
  else if(motorState == -1)
  */
  
  if ( myPort.available() > 0) {
    val = myPort.readStringUntil('\n'); 
  }
  println(val); //print it out in the console 
  
  
}

public void up(int theValue) {
  if(!setupDone) return;
  println("button= up");
  motorState = 1;
  myPort.write('U');
}

public void yield(int theValue) {
  if(!setupDone) return;
  println("button= stop");
  motorState = 0;
  myPort.write('S');
}

public void down(int theValue) {
  if(!setupDone) return;
  println("button= down");
  motorState = -1;
  myPort.write('D');
}
