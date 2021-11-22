/*
  adjust idle led animation
*/
import ch.bildspur.artnet.*;
ArtNetClient artnet;

int startMinute = 5;
int startSecond = 5;

void setup() {
  size(1000, 600, P2D);
  frameRate(60);
  surface.setLocation(0, 0);
  surface.setTitle("How To Walk On Water — Main");
  
  artnet = new ArtNetClient(null);
  artnet.start();
  
  initSetup();
  
  //mediaShowOffset 
}

void draw() {
  background(0);
  
  stateMachine(state);
  showOutputs();
  initOutputs();
  updateGUI();
}
