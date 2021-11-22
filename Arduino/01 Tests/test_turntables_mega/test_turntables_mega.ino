#include <AccelStepper.h>


// for the Arduino Uno + CNC shield V3

#define CNC_SHIELD_ENABLE_PIN 8

#define MOTOR_A_ENABLE_PIN 8
#define MOTOR_A_STEP_PIN 2
#define MOTOR_A_DIR_PIN 5


#define MOTOR_B_STEP_PIN 3
#define MOTOR_B_DIR_PIN 6

#define MOTOR_C_STEP_PIN 4
#define MOTOR_C_DIR_PIN 7




AccelStepper motorA(1, MOTOR_A_STEP_PIN, MOTOR_A_DIR_PIN);
AccelStepper motorB(1, MOTOR_B_STEP_PIN, MOTOR_B_DIR_PIN);
AccelStepper motorC(1, MOTOR_C_STEP_PIN, MOTOR_C_DIR_PIN);


void setup()
{
  motorA.setEnablePin(CNC_SHIELD_ENABLE_PIN);
  motorA.setPinsInverted(false, false, true);

  motorB.setEnablePin(CNC_SHIELD_ENABLE_PIN);
  motorB.setPinsInverted(false, false, true);

  motorC.setEnablePin(CNC_SHIELD_ENABLE_PIN);
  motorC.setPinsInverted(false, false, true);

  pinMode(CNC_SHIELD_ENABLE_PIN, OUTPUT);

  //motorA.setAcceleration(100);
  motorA.setMaxSpeed(300);
  motorA.setSpeed(100);

  motorB.setAcceleration(100);
  motorB.setMaxSpeed(100);
  motorB.setSpeed(100);

  motorC.setAcceleration(100);
  motorC.setMaxSpeed(100);
  motorC.setSpeed(100);



  motorA.enableOutputs();
  motorB.enableOutputs();
  motorC.enableOutputs();

}

void loop()
{

  motorA.runSpeed();
  motorB.runSpeed();
  //motorC.runSpeed();

}
