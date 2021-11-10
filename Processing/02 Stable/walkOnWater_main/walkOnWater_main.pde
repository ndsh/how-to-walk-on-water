import ch.bildspur.artnet.*;
ArtNetClient artnet;

void settings() {
  System.setProperty("jogl.disable.openglcore", "false");
  size(1000, 600, P2D);
}

void setup() {
  frameRate(60);
  surface.setLocation(0, 0);
  surface.setTitle("How To Walk On Water — Main");
  
  artnet = new ArtNetClient(null);
  artnet.start();
  
  initSetup();
}

void draw() {
  stateMachine(state);
}
