boolean cpInitDone = false;

float[] y = {1f};
float[] n = {0f};

Textlabel labelFPS;
Textlabel labelCurrentTime;

CheckBox checkboxOffline;
CheckBox checkboxPlayAudio;




void initCP5() {
  cp5 = new ControlP5(this);
  
  // LABELS
  labelFPS = cp5.addTextlabel("label1")
  .setText("LABEL_FRAMERATE")
  .setPosition(10, 10)
  ;
  
  labelCurrentTime = cp5.addTextlabel("label2")
  .setText("LABEL_CURRENT_TIME")
  .setPosition(10, height-30)
  ;
  
  // BUTTONS
  cp5.addButton("btnMediashow")
    .setValue(0)
    .setPosition(width-150, height-62)
    .setSize(150, 62)
    .setCaptionLabel("Mediashow")
    .setColorCaptionLabel(white)
    ;
    
  // CHECKBOXES
  checkboxOffline = cp5.addCheckBox("checkboxOffline")
  .setPosition(10,80)
  .setSize(31, 31)
  .addItem("scroll online", 1)
  ;
  
  checkboxPlayAudio = cp5.addCheckBox("checkboxPlayAudio")
  .setPosition(10,120)
  .setSize(31, 31)
  .addItem("audio", 1)
  ;

  checkboxOffline.setArrayValue((online?y:n));
  checkboxPlayAudio.setArrayValue((playAudio?y:n));

  cp5.setColorForeground(gray);
  cp5.setColorBackground(blue);
  cp5.setColorActive(white);
  cp5.setFont(font);
  cpInitDone = true;
}
public void btnMediashow(int i) {
  if (!cpInitDone) return;
  mediaShow = !mediaShow;

  if (mediaShow) {
    println("starting media show!");
    //mediaShow = true;
    //communicator.send("black", konterwandIP, konterwandPort);
    //communicator.send("black", vitrineIP, vitrinePort);
    ledsData = new byte[4][40*6];
    sendLEDs();
   // background(255);

  } else {
    println("stopping media show");
    timeline.init();
  }
}

void checkboxOffline(float[] a) {
  if (a[0] == 1f) online = true;
  else online = false;
  println("online=" + online);
}
