// HOW TO WALK ON WATER
// Mega on Turntables 

#include <RCSwitch.h>
RCSwitch mySwitch = RCSwitch();

const byte numChars = 96;
char receivedChars[numChars];
char tempChars[numChars];        // temporary array for use when parsing

char msgStart[numChars] = {0};
char msgEnd[numChars] = {0};

boolean newData = false;

boolean enableShieldCorners = false;
int vel[] = {0, 0, 0, 0};
int dir[] = {0, 0, 0, 0};
boolean enableShieldTurntables = false;
int turntableVel[] = {0, 0, 0};
boolean fansEnable = LOW;
boolean desktopLED = false;

//int fanPins[] = {30, 31, 32, 33, 34, 35, 36, 37};

// cnc shield
int ledPin = 13;
//int velocity = 0;
//int dir = 0;
boolean enable = false;
boolean validData = true;

int minVel = 0;
int maxVel = 200; // higher = more rpm

int SPU = 2048;


#include "globals.h"


void setup() {
  // put your setup code here, to run once:
  //Serial.begin(19200);
  Serial1.begin(19200);

  pinMode(ledPin, OUTPUT);
  pinMode(enablePin, OUTPUT);  

  mySwitch.enableTransmit(53);  // Der Sender wird an Pin 10 angeschlossen

  //digitalWrite(enablePin, LOW);
  enableMotors(LOW);
  for (uint8_t i = 0; i <  (sizeof(motors) / sizeof(motors[0])) ; i++) {
    motors[i].setMaxSpeed(vel[i]);
    motors[i].setSpeed(vel[i]*dir[i]);
  }

  Serial.println("Start Receive");

  if (Serial.available() > 0) {
    Serial.read();
    delay(50);
  }
  if (Serial1.available() > 0) {
    Serial1.read();
    delay(50);
  }

  Serial.println("start");

  //lightLED(); // works

}

void loop() {
  recvWithStartEndMarkers();
  if (newData == true) {
    strcpy(tempChars, receivedChars);
    // this temporary copy is necessary to protect the original data
    //   because strtok() used in parseData() replaces the commas with \0
    parseData();
    showParsedData();
    lightLED(desktopLED);
    newData = false;
    //fanControl(fansEnable);
    enableMotors(enableShieldTurntables);
  }
  moveMotors();
  
}

void recvWithStartEndMarkers() {
  static boolean recvInProgress = false;
  static byte ndx = 0;
  char startMarker = '<';
  char endMarker = '>';
  char rc;

  while (Serial1.available() > 0 && newData == false) {
    rc = Serial1.read();
    //Serial.println((char)rc);

    if (recvInProgress == true) {
      if (rc != endMarker) {
        receivedChars[ndx] = rc;
        ndx++;
        if (ndx >= numChars) {
          ndx = numChars - 1;
        }
      }
      else {
        receivedChars[ndx] = '\0'; // terminate the string
        recvInProgress = false;
        ndx = 0;
        newData = true;
      }
    }

    else if (rc == startMarker) {
      recvInProgress = true;
    }
    else {
      //Serial.print("Unexpected character: ");
      //Serial.println(rc);
    }
  }
}

//============

void parseData() {
  char * strtokIndx;
  /*
     ena[] = {false, false, false, false};
     int vel[] = {0, 0, 0, 0};
     int dir[] = {0, 0, 0, 0};
  */

  strtokIndx = strtok(tempChars, ",");
  strcpy(msgStart, strtokIndx);

  // Corners
  for (int i = 0; i < 4; i++) {
    strtokIndx = strtok(NULL, ",");
    vel[i] = atoi(strtokIndx);

    strtokIndx = strtok(NULL, ",");
    dir[i] = atoi(strtokIndx) == 1 ? 1 : -1;
  }

  strtokIndx = strtok(NULL, ",");
  enableShieldCorners = atoi(strtokIndx) == 1 ? true : false;

  // Turntables
  for (int i = 0; i < 3; i++) {
    strtokIndx = strtok(NULL, ",");
    turntableVel[i] = atoi(strtokIndx);
  }

  strtokIndx = strtok(NULL, ",");
  enableShieldTurntables = atoi(strtokIndx) == 1 ? true : false;

    // Fans
  strtokIndx = strtok(NULL, ",");
  fansEnable = atoi(strtokIndx) == 1 ? true : false;

  // Turntable Desktop LED
  strtokIndx = strtok(NULL, ",");
  desktopLED = atoi(strtokIndx) == 1 ? true : false;

  strtokIndx = strtok(NULL, ",");
  strcpy(msgEnd, strtokIndx);

}

//============

void showParsedData() {
  validData = false;
  if (strcmp(msgStart, "artnet") == 0 && strcmp(msgEnd, "eof") == 0) {
    for (int i = 0; i < 3; i++) {
      turntableVel[i] = map(turntableVel[i], 0, 255, minVel, maxVel);
      Serial.print("turntableVel[i]= ");
      Serial.print(turntableVel[i]);
      Serial.print("\t");
      Serial.print("enableShieldTurntables=");
      Serial.print(enableShieldTurntables);
      Serial.println("\t");
    }
    Serial.println(" * * * ");
    validData = true;
  }
}

void setVelocity(int v, int i) {
  vel[i] = v;
  motors[i].setMaxSpeed(vel[i]);
  motors[i].setSpeed(vel[i]*dir[i]);
  motors[i].runSpeed();
}

void enableMotors(boolean b) {
  // enablePin = LOW = active motors??
  enable = !b;
  digitalWrite(enablePin, enable);
}

void moveMotors() {
  if (!validData) return;

  for (int i = 0; i < 3; i++) {
    if (turntableVel[i] > 0) {
      //motors[i].setMaxSpeed(vel[i]);
      motors[i].setMaxSpeed(turntableVel[i]);
      //motors[i].setSpeed(vel[i]*dir[i]);
      motors[i].setSpeed(turntableVel[i]);
      motors[i].runSpeed();
    } else motors[i].stop();

  }

}


void lightLED(boolean b) {
  // code to activate to LED inside the center turntable via radio frequency 433mhz module
  if(b) {
    mySwitch.send(1234, 24);
    //delay(1000);
  }
}
