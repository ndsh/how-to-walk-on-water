#include <AccelStepper.h>

# define X_DIR 5 // X -axis stepper motor direction control
# define Y_DIR 6 // y -axis stepper motor direction control
# define Z_DIR 7 // z axis stepper motor direction control

# define X_STP 2 // x -axis stepper control
# define Y_STP 3 // y -axis stepper control
# define Z_STP 4 // z -axis stepper control
# define A_STP 12 // A -axis stepper control
# define A_DIR 13 // A axis stepper motor direction control

AccelStepper motorA(1, X_STP, X_DIR); // Motor closest to Arduino
AccelStepper motorB(1, Y_STP, Y_DIR); //
AccelStepper motorC(1, Z_STP, Z_DIR); //
AccelStepper motorD(1, A_STP, A_DIR); // Motor furthest away from Arduino

AccelStepper motors[] = {motorA, motorB, motorC, motorD};

const byte enablePin = 8; // nicht 100% sicher ob das so genutzt werden sollte. im cnc shield datenblatt mal nachgucken

AccelStepper motor1(AccelStepper::FULL4WIRE, 40, 42, 41, 43);
AccelStepper motor2(AccelStepper::FULL4WIRE, 44, 46, 45, 47);
AccelStepper motor3(AccelStepper::FULL4WIRE, 48, 50, 49, 51);

AccelStepper turntables[] = {motor1, motor2, motor3};
