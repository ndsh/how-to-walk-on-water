// HOW TO WALK ON WATER
// An installation by Irena Kukric
// Mechatronics by Julian Hespenheide

// Prototype: Serial control over a motor 

char val;
int ledPin = 13;
int velocity = 1000;
int dir = 0;

#include "globals.h"

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(enablePin, OUTPUT);
  digitalWrite(enablePin, LOW);
  Serial.begin(9600);

  for (uint8_t i = 0; i <  (sizeof(motors) / sizeof(motors[0])) ; i++) {
    motors[i].setMaxSpeed(12800);
    motors[i].setSpeed(1000);
  }
  
}

void loop() {
  while (Serial.available()) {
    val = Serial.read();
  }
  
  if (val == 'U') {
    dir = 1;
    for (int i = 0; i < 4; i++) {
      motors[i].setSpeed(velocity*dir);
      motors[i].runSpeed();
    }
    
  } else if(val == 'S') {
    for (int i = 0; i < 4; i++)
      motors[i].stop();
      
  } else if(val == 'D') {
    dir = -1;
    for (int i = 0; i < 4; i++) {
      motors[i].setSpeed(velocity*dir);
      motors[i].runSpeed();
    }
  }
  delay(100);
}