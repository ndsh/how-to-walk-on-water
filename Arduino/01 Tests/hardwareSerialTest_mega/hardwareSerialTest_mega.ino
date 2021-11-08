int incomingByte = 0; // for incoming serial data
String string;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(38400);
  Serial1.begin(38400);
  Serial.println("Start Receive on Arduino Mega");

  if (Serial.available() > 0) {
    Serial.read();
    delay(50);
  }
  if (Serial1.available() > 0) {
    Serial1.read();
    delay(50);
  }
  Serial.println("Start");
}

void loop() {
  // put your main code here, to run repeatedly:
  
    while (Serial1.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial1.read();
    //string = Serial1.readString();
    //String incomingString = Serial2.readString();


    // say what you got:
    //Serial.print("I received: ");
    //Serial.print((char)incomingByte);
    //string += (char)incomingByte;
    //Serial.println(incomingString);
    //Serial.println(string);
  }
  Serial.print(string);
  Serial.println();
  string = "";
}
