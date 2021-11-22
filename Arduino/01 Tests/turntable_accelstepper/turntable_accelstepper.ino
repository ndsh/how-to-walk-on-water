#include <AccelStepper.h>

int fanPins[] = {30, 31, 32, 33, 34, 35, 36, 37};

AccelStepper motor1(4, 40, 42, 41, 43);
AccelStepper motor2(4, 44, 46, 45, 47);
AccelStepper motor3(4, 48, 50, 49, 51);

int mSpeed = 200;

void setup() {
  // deactivate the fans
  for (int i = 0; i < 8; i++) {
    pinMode(fanPins[i], OUTPUT);
    digitalWrite(fanPins[i], LOW);
  }
  
  // put your setup code here, to run once:
  motor1.setMaxSpeed(mSpeed);
  motor1.setSpeed(mSpeed);
  motor2.setMaxSpeed(mSpeed);
  motor2.setSpeed(mSpeed);
  motor3.setMaxSpeed(mSpeed);
  motor3.setSpeed(mSpeed);
  

}

void loop() {
  // put your main code here, to run repeatedly:
  motor1.runSpeed();
  motor2.runSpeed();
  motor3.runSpeed();

}
