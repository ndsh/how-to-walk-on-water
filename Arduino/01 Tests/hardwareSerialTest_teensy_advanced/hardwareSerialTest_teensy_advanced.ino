#define HWSERIAL2 Serial2

void setup() {
  // put your setup code here, to run once:
  HWSERIAL2.begin(19200);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);

  if (Serial2.available() > 0) {
    Serial2.clear();
    delay(50);
  }
}

void loop() {
  static int messageCount = 0;
  // put your main code here, to run repeatedly:
  //HWSERIAL2.println("bonjour");
  HWSERIAL2.print("<");
  HWSERIAL2.print("artnet");
  HWSERIAL2.print(",");
  HWSERIAL2.print(420);
  HWSERIAL2.print(",");
  HWSERIAL2.print(69);
  HWSERIAL2.print(",");
  HWSERIAL2.print("eof");
  HWSERIAL2.println(">");

  if (++messageCount >= 5000) {
    Serial2.flush(); // wait for buffered data to transmit
    delayMicroseconds(10); // then wait approx 10 bit times
    messageCount = 0;
  }
}
