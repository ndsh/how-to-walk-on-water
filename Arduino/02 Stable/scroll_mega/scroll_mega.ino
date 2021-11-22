// HOW TO WALK ON WATER
// Uno on Scroll

const byte numChars = 96;
char receivedChars[numChars];
char tempChars[numChars];        // temporary array for use when parsing

char msgStart[numChars] = {0};
char msgEnd[numChars] = {0};

boolean newData = false;

int driverPUL = 9;      // PUL- pin
int driverDIR = 10;     // DIR- pin
int driverENA = 11;

boolean ena = false;
int vel = 0;
boolean dir = 0;
int pd = 500;           // Pulse Delay period

// cnc shield
int ledPin = 13;
//int velocity = 0;
//int dir = 0;
boolean enable = false;
boolean validData = true;

int minVel = 0;
int maxVel = 8000; // higher = more rpm

void setup() {
  // put your setup code here, to run once:
 // Serial.begin(19200);
  Serial1.begin(19200);

  pinMode(ledPin, OUTPUT);
  //pinMode(enablePin, OUTPUT);
  //digitalWrite(enablePin, LOW);
  enableMotors(LOW);

  pinMode(driverPUL, OUTPUT);
  pinMode(driverDIR, OUTPUT);
  pinMode(driverENA, OUTPUT);
  digitalWrite(driverENA, LOW);

  //Serial.println("Start Receive");

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
    
    newData = false;
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
   * ena[] = {false, false, false, false};
     int vel[] = {0, 0, 0, 0};
     int dir[] = {0, 0, 0, 0};
   */

  strtokIndx = strtok(tempChars, ",");
  strcpy(msgStart, strtokIndx);

  //for(int i = 0; i<4; i++) {
  strtokIndx = strtok(NULL, ",");
  ena = atoi(strtokIndx)==1?true:false;

  strtokIndx = strtok(NULL, ",");
  vel = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  dir = atoi(strtokIndx)==1?HIGH:LOW;
  //}

  strtokIndx = strtok(NULL, ",");
  strcpy(msgEnd, strtokIndx);

}

//============

void showParsedData() {
  validData = false;
  if (strcmp(msgStart, "artnet")==0 && strcmp(msgEnd, "eof")==0) {
    //for(int i = 0; i<4; i++) {
      Serial.print(ena);
      Serial.print("\t");
      //veli = map(vel[i], 0, 255, minVel, maxVel);
      Serial.print(vel);
      Serial.print("\t");
      Serial.print(dir);
      Serial.println("\t");
    //}
    Serial.println(" * * * ");
    validData = true;
  }
}

void setVelocity(int v, int i) {
  vel = v;
}

void enableMotors(boolean b) {
  // enablePin = LOW = active motors??
  enable = b;
  digitalWrite(driverENA, enable);
}

void moveMotors() {
  if(!validData) return;

  if(vel != 0) {
    pd = map(vel, 0, 255, 8000, 0);
    digitalWrite(driverDIR, dir);
    Serial.print("dir=");
    Serial.println(dir);
    digitalWrite(driverPUL, HIGH);
    delayMicroseconds(pd);
    digitalWrite(driverPUL, LOW);
    delayMicroseconds(pd);
  }
  
}
