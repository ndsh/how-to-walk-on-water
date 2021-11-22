color white = color(255);
color black = color(0);
color gray = color(125);
color blue = color(0, 0, 255);

float[] y = {1f};
float[] n = {0f};

CheckBox checkboxEnableScroll;
CheckBox checkboxEnableCurtains;
CheckBox checkboxEnableCorners;
CheckBox checkboxEnableTurntables;
CheckBox checkboxEnableLEDs;

CheckBox checkboxOnlineScroll;
CheckBox checkboxOnlineCurtains;
CheckBox checkboxOnlineCorners;

CheckBox checkboxLEDsBreathe;
CheckBox checkboxLEDsRun;


void cp5init() {
  cp5 = new ControlP5(this);
  
  checkboxLEDsBreathe = cp5.addCheckBox("checkboxLEDsBreathe")
  .setPosition(640, 30)
  .setSize(31, 31)
  .addItem("ledsBreathe", 1)
  ;
  
  checkboxLEDsRun = cp5.addCheckBox("checkboxLEDsRun")
  .setPosition(640, 64)
  .setSize(31, 31)
  .addItem("ledsRun", 1)
  ;
  
  checkboxOnlineScroll = cp5.addCheckBox("checkboxOnlineScroll")
  .setPosition(10,height-108)
  .setSize(31, 31)
  .addItem("online scroll", 1)
  ;
  
  checkboxOnlineCurtains = cp5.addCheckBox("checkboxOnlineCurtains")
  .setPosition(10,height-74)
  .setSize(31, 31)
  .addItem("online curtains", 1)
  ;
  
  checkboxOnlineCorners = cp5.addCheckBox("checkboxOnlineCorners")
  .setPosition(10,height-40)
  .setSize(31, 31)
  .addItem("online corners", 1)
  ;
 
 checkboxEnableScroll = cp5.addCheckBox("checkboxEnableScroll")
  .setPosition(160,10)
  .setSize(31, 31)
  .addItem("scroll", 1)
  ;
  
  cp5.addSlider("sliderScrollSpeed")
  .setPosition(160, 70)
  .setRange(0, 252)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
  ;

  cp5.addButton("btnScrollDir")
  .setValue(0)
  .setPosition(160, 90)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  // CURTAINS
  
  checkboxEnableCurtains = cp5.addCheckBox("checkboxEnableCurtains")
  .setPosition(160,150)
  .setSize(31, 31)
  .addItem("curtains", 1)
  ;
  
  cp5.addSlider("sliderCurtain0Speed")
  .setPosition(160, 190)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
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
  .setSliderMode(Slider.FLEXIBLE)
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
  .setSliderMode(Slider.FLEXIBLE)
  ;
  
  cp5.addButton("btnCurtain2Dir")
  .setValue(0)
  .setPosition(160, 370)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;

  
  
  cp5.addSlider("sliderCurtain3Speed")
  .setPosition(160, 430)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
  ;
  
  cp5.addButton("btnCurtain3Dir")
  .setValue(0)
  .setPosition(160, 450)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  // CORNERS
  checkboxEnableCorners = cp5.addCheckBox("checkboxEnableCorners")
  .setPosition(480, 10)
  .setSize(31, 31)
  .addItem("corners", 1)
  ;
  
  cp5.addSlider("sliderCorner0Speed")
  .setPosition(480, 70)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
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
  .setSliderMode(Slider.FLEXIBLE)
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
  .setSliderMode(Slider.FLEXIBLE)
  ;
  
  cp5.addButton("btnCorner2Dir")
  .setValue(0)
  .setPosition(480, 250)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
 
  cp5.addSlider("sliderCorner3Speed")
  .setPosition(480, 310)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
  ;
  
  cp5.addButton("btnCorner3Dir")
  .setValue(0)
  .setPosition(480, 330)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  checkboxEnableTurntables = cp5.addCheckBox("checkboxEnableTurntables")
  .setPosition(480, 385)
  .setSize(31, 15)
  .addItem("turntables", 1)
  ;
  
  checkboxEnableLEDs = cp5.addCheckBox("checkboxEnableLEDs")
  .setPosition(320, 530)
  .setSize(31, 31)
  .addItem("desktop led", 1)
  ;
  
  cp5.addSlider("sliderTurntable1")
  .setPosition(480, 420)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
  ;
  
  cp5.addSlider("sliderTurntable2")
  .setPosition(480, 460)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
  ;
  
  cp5.addSlider("sliderTurntable3")
  .setPosition(480, 500)
  .setRange(0, 254)
  .setSize(100, 16)
  .setCaptionLabel("")
  .setSliderMode(Slider.FLEXIBLE)
  ;
  
  cp5.addButton("btnFanEnable")
  .setValue(0)
  .setPosition(480, 355)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  cp5.addButton("btnTimerRun")
  .setValue(0)
  .setPosition(320, 570)
  .setSize(60, 16)
  .setCaptionLabel("timer")
  ;
  
  cp5.addButton("btnLEDsToggle")
  .setValue(0)
  .setPosition(640, 10)
  .setSize(60, 16)
  .setCaptionLabel("")
  ;
  
  checkboxEnableScroll.setArrayValue((scrollEnabled?y:n));
  checkboxEnableCurtains.setArrayValue((curtainsEnabled?y:n));
  checkboxEnableCorners.setArrayValue((cornersEnabled?y:n));
  checkboxEnableTurntables.setArrayValue((turntablesEnabled?y:n));
  
  checkboxEnableLEDs.setArrayValue((desktopLED?y:n));
  
  checkboxOnlineScroll.setArrayValue((online[0]?y:n));
  checkboxOnlineCurtains.setArrayValue((online[1]?y:n));
  checkboxOnlineCorners.setArrayValue((online[2]?y:n));
  
  checkboxLEDsBreathe.setArrayValue((ledsBreathe?y:n));
  
  cp5.setColorForeground(gray);
  cp5.setColorBackground(blue);
  cp5.setColorActive(white);
  cp5.setFont(font);
}

public void btnLEDsToggle(int theValue) {
  if (!cp5init) return;
  ledsToggle = !ledsToggle;
  println("toggleLEDs=" + ledsToggle);
  ledsBrightness((ledsToggle?(byte)255:(byte)0));
  ledsSend();
}

public void btnScrollDir(int theValue) {
  if (!cp5init) return;
  println("scrollDir=" + scrollDir);
  scrollDir = !scrollDir;
}

public void btnTimerRun(int theValue) {
  if (!cp5init) return;
  timerRun = !timerRun;
}

void sliderCurtain0Speed(int f) {
  if (!cp5init) return;
  curtainSpeeds[0] = f;
}

void sliderCurtain1Speed(int f) {
  if (!cp5init) return;
  curtainSpeeds[1] = f;
}

void sliderCurtain2Speed(int f) {
  if (!cp5init) return;
  curtainSpeeds[2] = f;
}

void sliderCurtain3Speed(int f) {
  if (!cp5init) return;
  curtainSpeeds[3] = f;
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

void sliderCorner0Speed(int f) {
  if (!cp5init) return;
  cornerSpeeds[0] = f;
}

void sliderCorner1Speed(int f) {
  if (!cp5init) return;
  cornerSpeeds[1] = f;
}

void sliderCorner2Speed(int f) {
  if (!cp5init) return;
  cornerSpeeds[2] = f;
}

void sliderCorner3Speed(int f) {
  if (!cp5init) return;
  cornerSpeeds[3] = f;
}

void sliderTurntable1(int f) {
  if (!cp5init) return;
  turntableSpeeds[0] = f;
}

void sliderTurntable2(int f) {
  if (!cp5init) return;
  turntableSpeeds[1] = f;
}

void sliderTurntable3(int f) {
  if (!cp5init) return;
  turntableSpeeds[2] = f;
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


// CHECKBOXES
void checkboxEnableScroll(float[] a) {
  if (a[0] == 1f) scrollEnabled = true;
  else scrollEnabled = false;
}

void checkboxEnableCurtains(float[] a) {
  if (a[0] == 1f) curtainsEnabled = true;
  else curtainsEnabled = false;
}

void checkboxEnableCorners(float[] a) {
  if (a[0] == 1f) cornersEnabled = true;
  else cornersEnabled = false;
}

void checkboxEnableTurntables(float[] a) {
  if (a[0] == 1f) turntablesEnabled = true;
  else turntablesEnabled = false;
}

void checkboxEnableLEDs(float[] a) {
  if (a[0] == 1f) desktopLED = true;
  else desktopLED = false;
}

void checkboxOnlineScroll(float[] a) {
  if (a[0] == 1f) online[0] = true;
  else online[0] = false;
}

void checkboxOnlineCurtains(float[] a) {
  if (a[0] == 1f) online[1] = true;
  else online[1] = false;
}

void checkboxOnlineCorners(float[] a) {
  if (a[0] == 1f) online[2] = true;
  else online[2] = false;
}

void checkboxLEDsBreathe(float[] a) {
  
  if (a[0] == 1f) ledsBreathe = true;
  else ledsBreathe = false;  
  ledsRun = false;
  println("leds breathe=" + ledsBreathe);
}

void checkboxLEDsRun(float[] a) {
  
  if (a[0] == 1f) ledsRun = true;
  else ledsRun = false;  
  ledsBreathe = false;
  println("leds run=" + ledsRun);
}

// end of cp5

int limiter(int val) {
  return (int)map(val, 0, 255, 0, maxBrightness);
}

int limiter(float val) {
  return (int)map(val, 0, 255, 0, maxBrightness);
}

void ledsBrightness(byte b) {
  for(int u = 0; u<2; u++) {
    for(int i = 0; i<ledsData[u].length; i++) {
      ledsData[u][i] = b;  
    }
  }
}

void ledsBreathe() {
  if(ledsBreathe) {
    for(int u = 0; u<2; u++) {
      for(int i = 0; i<ledsData[u].length; i++) {
        float val = (exp(sin(millis()/2000.0*(PI/8))) - 0.36787944)*108.0;
        val = limiter(val);
        ledsData[u][i] = (byte)val;
      }
    }
    ledsSend();
  }
}

void ledsRun() {
  byte b = 0;
  for(int u = 0; u<2; u++) {
    for(int i = 0; i<ledsData[u].length; i++) {
      ledsData[u][i] = b;  
    }
  }
}

void ledsSend() {
  for(int u = 0; u<2; u++) {
    artnet.unicastDmx("2.12.4.124", 0, u, ledsData[u]);
  }
}
