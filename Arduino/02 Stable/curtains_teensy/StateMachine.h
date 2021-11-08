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
      digitalWrite(LED_BUILTIN, LOW);
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
      digitalWrite(LED_BUILTIN, HIGH);
      //Serial.println("getting here");

      ena[0] = artnet.getDmxFrame()[0];
      vel[0] = artnet.getDmxFrame()[1];
      dir[0] = artnet.getDmxFrame()[2];
      
      ena[1] = artnet.getDmxFrame()[3];
      vel[1] = artnet.getDmxFrame()[4];
      dir[1] = artnet.getDmxFrame()[5];
      
      ena[2] = artnet.getDmxFrame()[6];
      vel[2] = artnet.getDmxFrame()[7];
      dir[2] = artnet.getDmxFrame()[8];
      
      ena[3] = artnet.getDmxFrame()[9];
      vel[3] = artnet.getDmxFrame()[10];
      dir[3] = artnet.getDmxFrame()[11];

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
       
      HWSERIAL2.print("<");
      HWSERIAL2.print("artnet");
      HWSERIAL2.print(",");
      for(int i = 0; i<4; i++) {
        HWSERIAL2.print(ena[i]);
        HWSERIAL2.print(",");
        HWSERIAL2.print(vel[i]);
        HWSERIAL2.print(",");
        HWSERIAL2.print(dir[i]);
        HWSERIAL2.print(",");
      }
      HWSERIAL2.print("eof");
      HWSERIAL2.println(">");
    
      if (++messageCount >= 5000) {
        HWSERIAL2.flush(); // wait for buffered data to transmit
        delayMicroseconds(10); // then wait approx 10 bit times
        messageCount = 0;
      }
      
      prevState = NETWORK;
      state = NETWORK;
    break;

  }
}
