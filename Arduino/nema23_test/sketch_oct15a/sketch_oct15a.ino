int reverseSwitch = 2;  // Push button for reverse
int driverPUL = 9;    // PUL- pin
int driverDIR = 10;    // DIR- pin
int driverENA = 11;
int spd = A0;     // Potentiometer
 
// Variables
 
int pd = 500;       // Pulse Delay period
boolean setdir = LOW; // Set Direction
 
// Interrupt Handler

long interval = 20000;
long timestamp = 0;
 
void revmotor (){
 
  setdir = !setdir;
  
}
 
 
void setup() {
 
  pinMode (driverPUL, OUTPUT);
  pinMode (driverDIR, OUTPUT);
  pinMode (driverENA, OUTPUT);
  digitalWrite(driverENA, LOW);
  //attachInterrupt(digitalPinToInterrupt(reverseSwitch), revmotor, FALLING);
  
}
 
void loop() {
  if(millis() - timestamp > interval) {
    timestamp = millis();
    //revmotor();
  }
    //pd = map((analogRead(spd)),0,1023,2000,50);
  digitalWrite(driverDIR,setdir);
  digitalWrite(driverPUL,HIGH);
  delayMicroseconds(pd);
  digitalWrite(driverPUL,LOW);
  delayMicroseconds(pd);
 
}
