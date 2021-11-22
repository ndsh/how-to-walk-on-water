void setup() {
  size(600, 600, P3D);
  surface.setLocation(0, 0);
  //  ortho(0, width, 0, height); // same as ortho()
  stroke(255);
  strokeWeight(3);
  noFill();
  noLights();
}

void draw() {
  //
  background(0);
  lights();

  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(-PI/6);
  //rotateY(map(mouseX, 0, width, 0, 2*PI));
  rotateY(radians(45));
  line(-100, -100, 0, 100, -100, 0);
  box(200);
  push();
  translate(0, -6, 0);
  box(200, 188, 200);
  pop();
  /*
  curtainPosition(0, map(mouseY, 0, height, 1.0, 0.0));
  curtainPosition(1, map(mouseY, 0, height, 1.0, 0.0));
  curtainPosition(2, map(mouseY, 0, height, 1.0, 0.0));
  curtainPosition(3, map(mouseY, 0, height, 1.0, 0.0));
  */
  curtainPosition(0, 0.9);
  curtainPosition(1, 0.9);
  curtainPosition(2, 0.9);
  curtainPosition(3, 0.9);
  popMatrix(); 



}

void curtainPosition(int curtainNr, float opened) {
  float val = map(opened, 1.0, 0.0, 0, 200);
  float val2 = 200-val;
  switch(curtainNr) {
    case 0:
      push();
      fill(255);
      noStroke();
      translate(val2/2, 0, 100);
      box(val, 200, 1);
      pop();
    break;
    
    case 1:
      push();
      fill(255);
      noStroke();
      rotateY(radians(180));
      translate(val2/2, 0, 100);
      box(val, 200, 1);
      pop();
    break;
    
    case 2:
      push();
      fill(255);
      noStroke();
      rotateY(radians(90));
      translate(val2/2, 0, 100);
      box(val, 200, 1);
      pop();
    break;
    
    case 3:
      push();
      fill(255);
      noStroke();
      rotateY(radians(270));
      translate(val2/2, 0, 100);
      box(val, 200, 1);
      pop();
    break;
  }
  
}
