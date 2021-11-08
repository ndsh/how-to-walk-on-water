//Receiver Code

const byte numChars = 96;
char receivedChars[numChars];
char tempChars[numChars];        // temporary array for use when parsing

char messageFromPC[numChars] = {0};
char messageFromPC2[numChars] = {0};
int integerFromPC = 0;
int integer2FromPC = 0;
float floatFromPC = 0.0;

boolean newData = false;

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

void parseData() {      // split the data into its parts

  char * strtokIndx; // this is used by strtok() as an index

  strtokIndx = strtok(tempChars, ",");     // get the first part - the string
  strcpy(messageFromPC, strtokIndx); // copy it to messageFromPC
  
  strtokIndx = strtok(NULL, ",");
  integerFromPC = atoi(strtokIndx);     // convert this part to an integer

  strtokIndx = strtok(NULL, ",");
  integer2FromPC = atoi(strtokIndx);     // convert this part to an integer
  //floatFromPC = atof(strtokIndx);     // convert this part to a float

  strtokIndx = strtok(NULL, ",");
  strcpy(messageFromPC2, strtokIndx); // copy it to messageFromPC

}

//============

void showParsedData() {
  //if (strcmp(messageFromPC, "artnet")==0 && strcmp(messageFromPC2, "eof")==0) {
    //Serial.print("Message ");
    //Serial.println(messageFromPC);
    
    Serial.print("Integer ");
    Serial.println(integerFromPC);
    
    Serial.print("Float ");
    Serial.println(integer2FromPC);
    
    //Serial.print("End Message ");
    //Serial.println(messageFromPC2);
    Serial.println("------\n");
  //}
}
