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

const byte enablePin = 8;

// Markov-Chain tristate probabilities
uint8_t states[3][3] =
{
  {75, 10, 15}, // up state
  {48, 4, 48}, // stop state
  {15, 10, 75} // down state
};

/*
 uint8_t states[3][3] =
{
  {75, 10, 15}, // up state
  {37, 26, 37}, // stop state
  {15, 10, 75} // down state
};
 */

uint8_t stepsScaling = 150; // one step * stepsScaling
int stepsMaximum = 2500;


uint8_t currentState[4] = {random(3),random(3),random(3),random(3)};
int countSteps[4] = {0, 0, 0, 0};

long timestamp[4] = {0, 0, 0, 0};
long interval[4] = {4000, 4000, 4000, 4000};
