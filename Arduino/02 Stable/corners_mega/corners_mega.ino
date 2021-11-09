// HOW TO WALK ON WATER
// Mega on Curtains

const byte numChars = 96;
char receivedChars[numChars];
char tempChars[numChars];        // temporary array for use when parsing

char msgStart[numChars] = {0};
char msgEnd[numChars] = {0};

boolean newData = false;

boolean ena[] = {false, false, false, false};
int vel[] = {0, 0, 0, 0};
int dir[] = {0, 0, 0, 0};
boolean turntableEna[] = {0, 0, 0};
int turntableVel[] = {0, 0, 0};
boolean fansEnable = 0;
boolean desktopLED = 0;

// cnc shield
int ledPin = 13;
//int velocity = 0;
//int dir = 0;
boolean enable = false;
boolean validData = true;

int minVel = 0;
int maxVel = 20000; // higher = more rpm

#include "globals.h"


void setup() {
  // put your setup code here, to run once:
  Serial.begin(19200);
  Serial1.begin(19200);

  pinMode(ledPin, OUTPUT);
  pinMode(enablePin, OUTPUT);


  pinMode(30, OUTPUT);
  pinMode(31, OUTPUT);
  pinMode(32, OUTPUT);
  pinMode(33, OUTPUT);
  pinMode(34, OUTPUT);
  pinMode(35, OUTPUT);
  pinMode(36, OUTPUT);
  pinMode(37, OUTPUT);

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

}

void loop() {
  recvWithStartEndMarkers();
  if (newData == true) {
    strcpy(tempChars, receivedChars);
    // this temporary copy is necessary to protect the original data
    //   because strtok() used in parseData() replaces the commas with \0
    parseData();
    showParsedData();
    moveTurntables();
    lightLED();
    newData = false;
  }

  enableCurtains();
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
    ena[i] = atoi(strtokIndx) == 1 ? true : false;

    strtokIndx = strtok(NULL, ",");
    vel[i] = atoi(strtokIndx);

    strtokIndx = strtok(NULL, ",");
    dir[i] = atoi(strtokIndx) == 1 ? 1 : -1;
  }

  // Fans
  strtokIndx = strtok(NULL, ",");
  fansEnable = atoi(strtokIndx) == 1 ? true : false;

  // Turntables
  for (int i = 0; i < 3; i++) {
    strtokIndx = strtok(NULL, ",");
    turntableEna[i] = atoi(strtokIndx) == 1 ? true : false;

    strtokIndx = strtok(NULL, ",");
    turntableVel[i] = atoi(strtokIndx);
  }

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
    for (int i = 0; i < 4; i++) {
      Serial.print(ena[i]);
      Serial.print("\t");
      vel[i] = map(vel[i], 0, 255, minVel, maxVel);
      Serial.print(vel[i]);
      Serial.print("\t");
      Serial.print(dir[i]);
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
  enable = b;
  digitalWrite(enablePin, enable);
}

void moveMotors() {
  if (!validData) return;

  for (int i = 0; i < 4; i++) {
    if (vel[i] > 0) {
      motors[i].setMaxSpeed(vel[i]);
      motors[i].setSpeed(vel[i]*dir[i]);
      motors[i].runSpeed();
    } else motors[i].stop();

  }

}

void enableCurtains() {
  digitalWrite(30, HIGH);
  digitalWrite(31, HIGH);
  digitalWrite(32, HIGH);
  digitalWrite(33, HIGH);
  digitalWrite(34, HIGH);
  digitalWrite(35, HIGH);
  digitalWrite(36, HIGH);
  digitalWrite(37, HIGH);

}

void moveTurntables() {
  // spin. the. wheels :)
}

void lightLED() {
  // code to activate to LED inside the center turntable via radio frequency 433mhz module
}
