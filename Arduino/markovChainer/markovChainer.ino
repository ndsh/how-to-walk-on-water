// windowStartingPoints
// An installation by Irena Kukric
// Mechatronics by Julian Hespenheide

// 3-bit

// Logic: 4 Motors
// Every 4 Steps the next motor is selected
// Each step can go [up, stale, down] => [1, 0, -1]
// A simple markov chain generates the next step
// If a border is hit/up down --> punish it and give the "other" side a bit more weight

#include "globals.h"

void setup() {
  //Serial.begin(9600);
  Serial.begin(115200);
  randomSeed(analogRead(0));
  Serial.println("windowStartingPoints");
  Serial.println("");
  Serial.println("/ / / / / / / /");
  Serial.println("");

  pinMode(enablePin, OUTPUT);
  digitalWrite(enablePin, LOW);

  for (uint8_t i = 0; i <  (sizeof(motors) / sizeof(motors[0])) ; i++) {
    motors[i].setMaxSpeed(12800);
    motors[i].setSpeed(1000);
  }



}

void loop() {

  // polling markov
  for (int i = 0; i < 4; i++)  {
    if (millis() - timestamp[i] > interval[i]) {
      timestamp[i] = millis();
      nextState(i);
    }
  }
  for (int i = 0; i < 4; i++) {
    if (isStep(i)) {
      stepsToDirection(i);
      moveSteps(i);
    }
    Serial.println();
  }
  Serial.print("------");
  Serial.println();

  
  /*
    for(uint8_t i = 0; i <  (sizeof(motors) / sizeof(motors[0])) ; i++) {
    motors[i].runSpeed();
    }
  */

}

void nextState(uint8_t index) {
  uint8_t rng = random(1, 101);
  /*
    Serial.print("rng= ");
    Serial.print(rng);
    Serial.print("\t");    Serial.print("\t");
  */
  //    Serial.print(states[currentState]);
  int borders[3];
  int indices[3];
  for (uint8_t i = 0; i < (sizeof(states[currentState[index]]) / sizeof(states[currentState[index]][0])); i++)  {
    //Serial.print(states[currentState[index]][i]);
    borders[i] = states[currentState[index]][i];
    if (i != 0) borders[i] += borders[i - 1];
    //Serial.print(" ");
  }

  uint8_t leftBorder = 0;
  uint8_t rightBorder = borders[0];
  //Serial.print("\t");
  for (int i = 0; i < 3; i++) {
    if (i != 0) {
      leftBorder = borders[i - 1];
      rightBorder = borders[i];
    }
    /*
      Serial.print("border=");
      Serial.print(borders[i]);
      Serial.print("\t");
    */
    if (rng > leftBorder && rng <= rightBorder) {
      /*
        Serial.print("state= ");
        Serial.print(i);
        Serial.print("\t");
      */
      if (currentState[index] != i) currentState[index] = i;
      /*
        Serial.print("currentState= ");
        Serial.print(currentState[index]);
      */
      break;
    }
  }

}

void stepsToDirection(uint8_t index) {
  if (currentState[index] == 0) countSteps[index] += 1;
  else if (currentState[index] == 1) countSteps[index] += 0;
  else if (currentState[index] == 2) countSteps[index] += -1;
  Serial.print("[");
  Serial.print(index);
  Serial.print("] ");
  Serial.print("countSteps=");
  Serial.print(countSteps[index]);
}

void moveSteps(uint8_t index) {
  int dir = 0;
  if (currentState[index] == 0) dir = 1;
  else  if (currentState[index] == 2) dir = -1;
  if (dir != 0) {
    //for(int i = 0; i<stepsScaling; i++) {
    int velocity = 1000;
    motors[index].setSpeed(velocity*dir);
    motors[index].runSpeed();
    //}
  } else motors[index].stop();

}

boolean isStep(uint8_t index) {
  /*
    Serial.print("\t"); Serial.print("\t");
    Serial.print(currentState[index]);
    Serial.print("\t");
    Serial.print(countSteps[index]);
  */
  if (currentState[index] == 0 && countSteps[index] > stepsMaximum) return false;
  else if (currentState[index] == 2 && countSteps[index] < (stepsMaximum * -1)) return false;
  else return true;
}
