final int SETUP = 0;
final int IDLE = 1;
final int SHOW = 2;
final int SEND = 3;

int state = SETUP;

String[] namedStates = {"SETUP"};

void stateMachine(int _state) {
  switch(_state) {
    case SETUP:
      state = IDLE;
    break;
    
    case IDLE:
      state = IDLE;
      if(mediaShow) state = SHOW;
      
    break;
    
    case SHOW:
      if(mediaShow) ;//animator.black();
      if(!timeline.isReady() && !timeline.isGoing()) {
        timeline.init();
      } else {
        if(!timeline.isGoing()) timeline.go();
        timeline.update();
        if(timeline.isFinished()) {
          mediaShow = false;
          /*konterwandTimestamp = -1000000000;
          vitrineTimestamp = -1000000000;
          basicledTimestamp = -1000000000;*/
          println("media show over.");
        }
      }
      state = IDLE;
    break;
  }
}
