color white = color(255);
color black = color(0);
color gray = color(125);
color blue = color(0, 0, 255);

void cp5init() {
  cp5 = new ControlP5(this);
  cp5.addSlider("sliderScrollSpeed")
  .setPosition(160, 70)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;

  cp5.addButton("btnScrollDir")
  .setValue(0)
  .setPosition(160, 90)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  // CURTAINS
  cp5.addSlider("sliderCurtain0Speed")
  .setPosition(160, 190)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCurtain0Dir")
  .setValue(0)
  .setPosition(160, 210)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addSlider("sliderCurtain1Speed")
  .setPosition(160, 270)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCurtain1Dir")
  .setValue(0)
  .setPosition(160, 290)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addSlider("sliderCurtain2Speed")
  .setPosition(160, 350)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCurtain2Dir")
  .setValue(0)
  .setPosition(160, 370)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;

  cp5.setColorForeground(gray);
  cp5.setColorBackground(blue);
  cp5.setColorActive(white);
  cp5.setFont(font);
  
  cp5.addSlider("sliderCurtain3Speed")
  .setPosition(160, 430)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCurtain3Dir")
  .setValue(0)
  .setPosition(160, 450)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  // CORNERS
  cp5.addSlider("sliderCorner0Speed")
  .setPosition(480, 70)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCorner0Dir")
  .setValue(0)
  .setPosition(480, 90)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addSlider("sliderCorner1Speed")
  .setPosition(480, 150)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCorner1Dir")
  .setValue(0)
  .setPosition(480, 170)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addSlider("sliderCorner2Speed")
  .setPosition(480, 230)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCorner2Dir")
  .setValue(0)
  .setPosition(480, 250)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;

  cp5.setColorForeground(gray);
  cp5.setColorBackground(blue);
  cp5.setColorActive(white);
  cp5.setFont(font);
  
  cp5.addSlider("sliderCorner3Speed")
  .setPosition(480, 310)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnCorner3Dir")
  .setValue(0)
  .setPosition(480, 330)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnFanEnable")
  .setValue(0)
  .setPosition(480, 355)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
}


public void btnScrollDir(int theValue) {
  if (!cp5init) return;
  println("scrollDir=" + scrollDir);
  scrollDir = !scrollDir;
}

void sliderCurtain0Speed(float f) {
  if (!cp5init) return;
  curtainSpeeds[0] = (int)f;
}

void sliderCurtain1Speed(float f) {
  if (!cp5init) return;
  curtainSpeeds[1] = (int)f;
}

void sliderCurtain2Speed(float f) {
  if (!cp5init) return;
  curtainSpeeds[2] = (int)f;
}

void sliderCurtain3Speed(float f) {
  if (!cp5init) return;
  curtainSpeeds[3] = (int)f;
}

public void btnCurtain0Dir(int theValue) {
  if (!cp5init) return;
  println("curtainDirs[0]=" + curtainDirs[0]);
  curtainDirs[0] = !curtainDirs[0];
}

public void btnCurtain1Dir(int theValue) {
  if (!cp5init) return;
  println("curtainDirs[1]=" + curtainDirs[1]);
  curtainDirs[1] = !curtainDirs[1];
}

public void btnCurtain2Dir(int theValue) {
  if (!cp5init) return;
  println("curtainDirs[2]=" + curtainDirs[2]);
  curtainDirs[2] = !curtainDirs[2];
}

public void btnCurtain3Dir(int theValue) {
  if (!cp5init) return;
  println("curtainDirs[3]=" + curtainDirs[3]);
  curtainDirs[3] = !curtainDirs[3];
}

void sliderCorner0Speed(float f) {
  if (!cp5init) return;
  cornerSpeeds[0] = (int)f;
}

void sliderCorner1Speed(float f) {
  if (!cp5init) return;
  cornerSpeeds[1] = (int)f;
}

void sliderCorner2Speed(float f) {
  if (!cp5init) return;
  cornerSpeeds[2] = (int)f;
}

void sliderCorner3Speed(float f) {
  if (!cp5init) return;
  cornerSpeeds[3] = (int)f;
}

public void btnCorner0Dir(int theValue) {
  if (!cp5init) return;
  println("cornerDirs[0]=" + cornerDirs[0]);
  cornerDirs[0] = !cornerDirs[0];
}

public void btnCorner1Dir(int theValue) {
  if (!cp5init) return;
  println("cornerDirs[1]=" + cornerDirs[1]);
  cornerDirs[1] = !cornerDirs[1];
}

public void btnCorner2Dir(int theValue) {
  if (!cp5init) return;
  println("cornerDirs[2]=" + cornerDirs[2]);
  cornerDirs[2] = !cornerDirs[2];
}

public void btnCorner3Dir(int theValue) {
  if (!cp5init) return;
  println("cornerDirs[3]=" + cornerDirs[3]);
  cornerDirs[3] = !cornerDirs[3];
}

public void btnFanEnable(int theValue) {
  if (!cp5init) return;
  println("fansEnable=" + fansEnable);
  fansEnable = !fansEnable;
}
