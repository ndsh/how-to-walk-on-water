#define INTRO 0
#define UPDATE 1
#define RUN 2
#define NETWORK 3
#define DATA 4

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
        state = RUN;
      }
      if(prevState != state) showStateTitle = true;
     else showStateTitle = false;
    break;


    case RUN:
      // normaler code ¯\_(ツ)_/¯
      if(showStateTitle) Serial.println("→ Run");   
      
      prevState = state;
      state = UPDATE;
    break;

    case NETWORK:
      if(showStateTitle || prevState == DATA) {
        Serial.println("→ Network");
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
        
        
        millisKeepAlive = millis();
      } else //Serial.println("no data available");
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
      // beispiel mit leds
      //runIdleFlipdigitCounter();
      //if(artnet.getUniverse() == 0) runFlipdotsDataSingleUniverse();
      //else runFlipdotsDataMultiUniverse();
      
      
      //delay(20);
      prevState = NETWORK;
      state = NETWORK;
    break;

  }
}
