// HOW TO WALK ON WATER
// Teensy on Curtains
#define HWSERIAL2 Serial2

int ena[] = {1, 1, 1, 1};
int vel[] = {0, 0, 0, 0};
int dir[] = {0, 0, 0, 0};

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
    Serial2.flush(); // wait for buffered data to transmit
    delayMicroseconds(10); // then wait approx 10 bit times
    messageCount = 0;
  }
}
