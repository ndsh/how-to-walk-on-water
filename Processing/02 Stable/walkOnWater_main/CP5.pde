boolean cpInitDone = false;

float[] y = {1f};
float[] n = {0f};

void initCP5() {
  cp5 = new ControlP5(this);
  cp5.addButton("btnMediashow")
    .setValue(0)
    .setPosition(147, 540)
    .setSize(150, 62)
    .setCaptionLabel("Mediashow")
    .setColorCaptionLabel(white)
    ;
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
  } else {
    println("stopping media show");
    timeline.init();
  }
}
