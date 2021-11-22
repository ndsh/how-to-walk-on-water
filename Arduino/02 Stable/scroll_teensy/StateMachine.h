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
      //digitalWrite(LED_BUILTIN, LOW);
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
      } else //Serial.println("no data available");
      if(millis() - millisKeepAlive < 5000) { // läuft loop hier zu lange? checken
        networkDataAvailable = true;
      }

      prevState = state;
      if(networkDataAvailable) state = DATA;
      else {
        state = UPDATE;
      }
    break;

    case DATA:
      // save frame from artnet
      r = artnet.read();
      u = 0;

      Serial.println(artnet.getLength());
      if(artnet.getLength() == 0) {
        return;
        prevState = NETWORK;
        state = NETWORK;
      }
      
      //Serial.println("getting here");

      ena = artnet.getDmxFrame()[0];
      vel = artnet.getDmxFrame()[1];
      dir = artnet.getDmxFrame()[2];
     

      static int messageCount = 0;
      // forward to arduino mega with cnc shield
      //  static int messageCount = 0;
      // we will have to send 12 values via Artnet
      /*
       * [1] Enable Curtain 1
       * [2] Velocity of Curtain 1
       * [3] Direction of Curtain 1
       * […] …
       * [10] Velocity of Curtain 4
       * [11] Direction of Curtain 4
       * <artnet,e1,v1,d1,…,e4,v4,d4,eof>
       */
       
      HWSERIAL3.print("<");
      HWSERIAL3.print("artnet");
      HWSERIAL3.print(",");
      HWSERIAL3.print(ena);
      HWSERIAL3.print(",");
      HWSERIAL3.print(vel);
      HWSERIAL3.print(",");
      HWSERIAL3.print(dir);
      HWSERIAL3.print(",");
      HWSERIAL3.print("eof");
      HWSERIAL3.println(">");
    
      if (++messageCount >= 5000) {
        HWSERIAL3.flush(); // wait for buffered data to transmit
        delayMicroseconds(10); // then wait approx 10 bit times
        messageCount = 0;
      }
      
      prevState = NETWORK;
      state = NETWORK;
    break;

  }
}
