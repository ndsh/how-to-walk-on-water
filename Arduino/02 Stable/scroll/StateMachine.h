#define INTRO 0
#define UPDATE 1
#define NETWORK 2
#define DATA 3

int state = 0;

void stateMachine() {
  switch (state) {
    case INTRO:
      Serial.println("→ Intro");      
      state = UPDATE;
      Serial.println("→ Switch to Update");
      showStateTitle = true;
    break;

    case UPDATE:
      //Serial.println("→ Update");
      if(millis() - millisEthernetStatusLink > millisEthernetStatusDelay) {
        millisEthernetStatusLink = millis();
        linkEthernetStatus = checkEthernetLinkStatus();
      }
      if(networkDataAvailable) {
        state = NETWORK;
      } else if(millis() - millisRecheckNetwork > delayNetworkCheck && linkEthernetStatus) {
        millisRecheckNetwork = millis();
        state = NETWORK;
      } else {
        state = UPDATE;
      }
      if(prevState != state) showStateTitle = true;
     else showStateTitle = false;
    break;

    case NETWORK:
      if(showStateTitle || prevState == DATA) {
        //Serial.println("→ Network");
        showStateTitle = false;
      }
      r = 0;
      r = artnet.read();
      networkDataAvailable = false;
      
      if(r == 0) {
        //Serial.println("no data available");
      }
      if(r == ART_POLL) {
        Serial.println("POLL");
      }
      if (r == ART_DMX) {
        // print out our data
        networkDataAvailable = true;

        /*
        Serial.print("universe number = ");
        Serial.print(artnet.getUniverse());
        Serial.print("\tdata length = ");
        Serial.print(artnet.getLength());
        Serial.print("\tsequence n0. = ");
        Serial.println(artnet.getSequence());
        Serial.print("DMX data: ");
        for (int i = 0 ; i < artnet.getLength() ; i++) {
          Serial.print(artnet.getDmxFrame()[i]);
          Serial.print("  ");
        }
        Serial.println();
        Serial.println();
        */
        
        millisKeepAlive = millis();
      } else ; //Serial.println("no data available");
      if(millis() - millisKeepAlive < 5000) {
        networkDataAvailable = true;
      }

      prevState = state;
      if(networkDataAvailable) state = DATA;
      else {
        state = UPDATE;
      }
    break;

    case DATA:
      // artnet frames aus dem netzwerk abspielen
      // enable     -> 0
      // speed      -> 1
      // direction  -> 2
      // pulse      -> 3

      r = artnet.read();
      u = 0;
      
      if(artnet.getLength() == 0) {
        return;
        prevState = NETWORK;
        state = NETWORK;
      }
      //Serial.println("its data time");
      
      int motorEnabled = artnet.getDmxFrame()[0];
      int motorSpeed = artnet.getDmxFrame()[1];
      int motorDirection = artnet.getDmxFrame()[2];
      int motorPulse = artnet.getDmxFrame()[3];

      boolean isEnabled = motorEnabled==1?true:false;
      boolean direction = motorSpeed==1?true:false; // true = up, false = down
      
      pd = map(motorSpeed, 0, 255, 8000, 0);

      digitalWrite(driverDIR, motorDirection);
      digitalWrite(driverPUL, HIGH);
      delayMicroseconds(pd);
      digitalWrite(driverPUL, LOW);
      delayMicroseconds(pd);
      
      prevState = NETWORK;
      state = NETWORK;
    break;

  }
}
