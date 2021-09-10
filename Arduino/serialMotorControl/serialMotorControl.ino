// HOW TO WALK ON WATER
// An installation by Irena Kukric
// Mechatronics by Julian Hespenheide

// Prototype: Serial control over a motor 

char val;
int ledPin = 13;
int velocity = 300;
int dir = 0;

#include "globals.h"

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(enablePin, OUTPUT);
  digitalWrite(enablePin, LOW);
  Serial.begin(9600);

  for (uint8_t i = 0; i <  (sizeof(motors) / sizeof(motors[0])) ; i++) {
    motors[i].setMaxSpeed(velocity);
    motors[i].setSpeed(velocity);
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
  } else if(val == '1') {
    setVelocity(300);
  } else if(val == '2') {
    setVelocity(500);
  } else if(val == '3') {
    setVelocity(700);
  } else if(val == '4') {
    setVelocity(900);
  } else if(val == '5') {
    setVelocity(5000);
  } else if(val == '6') {
    setVelocity(20000);
  }
  //delay(100);
}

void setVelocity(int v) {
  velocity = v;
  for (int i = 0; i < 4; i++) {
    motors[i].setMaxSpeed(v);
    motors[i].setSpeed(v*dir);
  }
}
