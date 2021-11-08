//Receiver Code

const byte numChars = 96;
char receivedChars[numChars];
char tempChars[numChars];        // temporary array for use when parsing

char msgStart[numChars] = {0};
char msgEnd[numChars] = {0};

boolean newData = false;

boolean ena[] = {false, false, false, false};
int vel[] = {0, 0, 0, 0};
int dir[] = {0, 0, 0, 0};

void setup() {
  // put your setup code here, to run once:
  Serial.begin(19200);
  Serial1.begin(19200);

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
    newData = false;
  }
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

  strtokIndx = strtok(NULL, ",");
  ena[0] = atoi(strtokIndx)==1?true:false;

  strtokIndx = strtok(NULL, ",");
  vel[0] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  dir[0] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  ena[1] = atoi(strtokIndx)==1?true:false;

  strtokIndx = strtok(NULL, ",");
  vel[1] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  dir[1] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  ena[2] = atoi(strtokIndx)==1?true:false;

  strtokIndx = strtok(NULL, ",");
  vel[2] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  dir[2] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  ena[3] = atoi(strtokIndx)==1?true:false;

  strtokIndx = strtok(NULL, ",");
  vel[3] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  dir[3] = atoi(strtokIndx);

  strtokIndx = strtok(NULL, ",");
  strcpy(msgEnd, strtokIndx);

}

//============

void showParsedData() {
  if (strcmp(msgStart, "artnet")==0 && strcmp(msgEnd, "eof")==0) {    
    Serial.println(ena[0]);
    Serial.println("------\n");
  }
}
