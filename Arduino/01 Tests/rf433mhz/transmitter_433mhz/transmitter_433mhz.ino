#include <RCSwitch.h>
RCSwitch mySwitch = RCSwitch();

void setup() {
  //Serial.begin(19200);
  mySwitch.enableTransmit(10);  // Der Sender wird an Pin 10 angeschlossen

}
void loop() {
  //Serial.println("send");
  mySwitch.send(1234, 24); // Der 433mhz Sender versendet die Dezimalzahl „1234“
  delay(1000);  // Eine Sekunde Pause, danach startet der Sketch von vorne
}  
