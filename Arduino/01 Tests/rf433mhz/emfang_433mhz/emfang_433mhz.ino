
#include <RCSwitch.h>

RCSwitch mySwitch = RCSwitch();
boolean dataPresent = false;

void setup() {
  Serial.begin(9600);
  mySwitch.enableReceive(0);  // Receiver on interrupt 0 => that is pin #2
}

void loop() {
  dataPresent = false;
  if (mySwitch.available()) {
    int value = mySwitch.getReceivedValue();
    dataPresent = true;
    Serial.print("Received ");
    Serial.print( mySwitch.getReceivedValue() );
    Serial.print(" / ");
    Serial.print( mySwitch.getReceivedBitlength() );
    Serial.print("bit ");
    Serial.print("Protocol: ");
    Serial.println( mySwitch.getReceivedProtocol() );
    if(value == 1234) dataPresent = true;
    mySwitch.resetAvailable();
  }
  Serial.println(dataPresent);
}
