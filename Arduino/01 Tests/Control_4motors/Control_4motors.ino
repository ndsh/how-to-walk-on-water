// HOW TO WALK ON WATER
// An installation by Irena Kukric
// Mechatronics by Julian Hespenheide

// Prototype: Serial control over a motor 

char val;
int ledPin = 13;
int velocity = 300;
int dir = 0;
boolean enable = false;

#include "globals.h"

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(enablePin, OUTPUT);
  //digitalWrite(enablePin, LOW);
  enableMotors(HIGH);
  Serial.begin(9600);

  for (uint8_t i = 0; i <  (sizeof(motors) / sizeof(motors[0])) ; i++) {
    motors[i].setMaxSpeed(velocity);
    motors[i].setSpeed(velocity);
  }
  
}

void loop() {
  for (int i = 0; i < 4; i++) {

      motors[i].setSpeed(velocity*dir);
      motors[i].runSpeed();
   }
}

void setVelocity(int v) {
  velocity = v;
  for (int i = 0; i < 4; i++) {
    motors[i].setMaxSpeed(v);
    motors[i].setSpeed(v*dir);
    motors[i].runSpeed();
  }
}

void enableMotors(boolean b) {
  enable = b;
  digitalWrite(enablePin, enable);
}
