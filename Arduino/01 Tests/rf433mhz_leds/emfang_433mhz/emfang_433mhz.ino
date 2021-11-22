#include <Adafruit_NeoPixel.h>
#include <RCSwitch.h>

RCSwitch mySwitch = RCSwitch();
boolean dataPresent = false;
int ledPin = 9;
int numpixels = 60;

Adafruit_NeoPixel pixels(numpixels, ledPin, NEO_GRB + NEO_KHZ800);

void setup() {
  //Serial.begin(9600);
  mySwitch.enableReceive(0);  // Receiver on interrupt 0 => that is pin #2
  pixels.begin();
}

void loop() {
  pixels.clear();
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
  if(dataPresent) {
    Serial.println("hello");
    for(int i = 0; i<numpixels; i++) {
      pixels.setPixelColor(i, pixels.Color(125, 125, 125));
    }
    pixels.show();
   }
}
