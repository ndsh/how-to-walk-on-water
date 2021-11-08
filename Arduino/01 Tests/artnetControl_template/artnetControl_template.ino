/*
 * todo
 */

//enable ETHERNET_LARGE_BUFFERS , e.g. uncomment the following line: https://github.com/PaulStoffregen/Ethernet/blob/master/src/Ethernet.h#L48
#include "Helper.h"
#include "StateMachine.h"


void setup() {
  setupEnv();
}

void loop() {
  stateMachine();
}
