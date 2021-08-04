char val;
int ledPin = 13;

void setup() {
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
  Serial.begin(9600); // Start serial communication at 9600 bps
}

void loop() {
  while (Serial.available()) {
    val = Serial.read();
  }
  
  if (val == 'U') {
    digitalWrite(ledPin, HIGH);
    Serial.println("UUU");
  } else if(val == 'S') {
    digitalWrite(ledPin, LOW);
    Serial.println("SSS");
  } else if(val == 'D') {
    digitalWrite(ledPin, LOW);
    Serial.println("DDD");
  }
  delay(100);
}
