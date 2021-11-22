int fanPins[] = {30, 31, 32, 33, 34, 35, 36, 37};

long timestamp = 0;
long interval = 5000;

boolean fanState = true;

void setup() {
  for (int i = 0; i < 8; i++) {
    pinMode(fanPins[i], OUTPUT);
    digitalWrite(fanPins[i], LOW);
  }

}

void loop() {
  if(millis() - timestamp > interval) {
    timestamp = millis();
    fanState = !fanState;
    fanControl(fanState);
  }

}

void fanControl(boolean b) {
  for (int i = 0; i < 8; i++) {
    digitalWrite(fanPins[i], b);
  }
}
