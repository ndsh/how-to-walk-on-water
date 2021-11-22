// Class to run the media show
// Here we combine bunch of the other classes to route the pixels where we want them to go
// This class can or should only be started by Organizer or the StateMachine and finishes cleanly at one point
// cleanly = all
// what states of timeliner are needed to communicate to the outside world that we are: ready, hasFinished or started?
// can these states be summed up?

// We need to load the timeline.json

// curtains booleans
// closing = true / opening = false
//
class Timeline {
  boolean go = false;
  boolean isFinished = false;
  boolean isReady = false;
  long startTime = 0;
  long delta = 0;
  ArrayList<Chunk> chunks = new ArrayList<Chunk>();

  public Timeline() {
  }

  // reset variables
  void init() {
    go = false;
    isFinished = false;
    isReady = true;
    for (int i = 0; i<chunks.size(); i++) {
      chunks.get(i).init();
    }
  }

  void go() {
    if (isReady) {
      go = true;
      startTime = millis();
      isReady = false;
    } else {
      println("Timeline has not been readied yet.");
    }
  }

  void update() {
    if (go) {

      delta = millis()-startTime;
      push();
      fill(255);
      //text(((delta/1000)/60) +":"+ ((delta/1000)/60), 10, height-30);
      labelCurrentTime.setText( nf(int(((delta+mediaShowOffset)/1000)/60), 2) +":"+ nf(int(((delta+mediaShowOffset)/1000)%60), 2) );
      //if(delta % 30000 == 0) println("--> Elapsed delta time= " + ((delta/1000)/60) +":"+ ((delta/1000)/60));
      pop();

      for (int i = 0; i<chunks.size(); i++) {
        chunks.get(i).update();
      }
      isFinished();
      if (isFinished) go = false;
    }
  }

  boolean isFinished() {
    for (int i = 0; i<chunks.size(); i++) {
      isFinished = chunks.get(i).isFinished();
    }
    return isFinished;
  }

  boolean isReady() {
    return isReady;
  }

  boolean isGoing() {
    return go;
  }

  void getUnfinished() {
  }

  void getFinished() {
  }


  void addChunk(long time, long duration, String message, String module) {
    chunks.add(new Chunk(time, duration, message, module));
  }

  Chunk getChunk(int i) {
    return chunks.get(i);
  }

  // A chunk is a piece of a timeline
  // timecode is relative to startTime in milliseconds
  class Chunk {
    long timecode = 0;
    long duration = 0;
    int aniID = 0;
    String message = "";
    String module = "";

    int motorNr = 0;

    boolean finished = false;
    boolean executeUDPonce = false;
    boolean executeCasambiOnce = false;

    boolean scrollEnabled = true;
    int scrollSpeed = 0;
    boolean scrollDir = false;

    boolean curtainsEnabled = true;
    int[] curtainSpeeds = {0, 0, 0, 0};
    boolean[] curtainDirs = {true, true, true, true};

    boolean cornersEnabled = true;
    int[] cornerSpeeds = {0, 0, 0, 0};
    boolean[] cornerDirs = {true, true, true, true};

    boolean turntablesEnabled = true;
    int[] turntableSpeeds = {125, 125, 125, 125};

    boolean fansEnable = false;
    boolean desktopLED = false;


    public Chunk(long time, long _duration, String _message, String _module) {
      timecode = time;
      //println(timecode);
      duration = _duration;
      message = _message;
      module = _module;
    }

    void update() {
      
      
      if ( (delta >= timecode && (delta <= timecode+duration)) && ( (timecode+mediaShowOffset) > mediaShowOffset) ) {
        //println(message + "// " + timecode + " " + mediaShowOffset);
        //println(timecode + " / " + module);
        currentChunk.append(timecode + " / " + module);
        // do stuff here
        populateData();
        send();
      } else if (delta > timecode+duration) {
        unPopulateData();
        send();
        finished = true;
      }
    }

    boolean isFinished() {
      return finished;
    }

    void init() {
      finished = false;
    }

    void populateData() {
      if (module.equals("scroll")) {
        scrollData[0] = (byte) 1;
        scrollData[1] = (byte) scrollSpeed; //map(scrollSpeed, 0, 100, 0, 255);
        scrollData[2] = (byte) (scrollDir?1:0);
      } else if (module.equals("curtains")) {
        //curtainsData[motorNr*3+0] = (byte) 1; //(curtainEnables[i]?1:0);
        curtainsData[motorNr*2+0] = (byte) curtainSpeeds[motorNr]; // int(map(curtainSpeeds[motorNr], 0, 100, 0, 255)); // conversion from 0-10 to the 0-255 range
        //println("curtains vel= " + map(curtainSpeeds[motorNr], 0, 100, 0, 255));
        curtainsData[motorNr*2+1] = (byte) (curtainDirs[motorNr]?1:0);
        curtainsData[8] = (byte) 1; //(curtainsEnabled?1:0);
      } else if (module.equals("corners")) {
        //cornersData[motorNr*3+0] = (byte) 1;
        cornersData[motorNr*2+0] = (byte) cornerSpeeds[motorNr]; // map(cornerSpeeds[motorNr], 0, 100, 0, 255); // conversion from 0-10 to the 0-255 range
        cornersData[motorNr*2+1] = (byte) (cornerDirs[motorNr]?1:0);
        cornersData[8] = (byte) 1;
      } else if (module.equals("fans")) {
        cornersData[13] = (byte) (fansEnable?1:0);
      } else if (module.equals("leds")) {
      } else if (module.equals("turntables")) {
        //cornersData[motorNr*2+13] = (byte) 1;
        cornersData[motorNr+9] = (byte) turntableSpeeds[motorNr];
        cornersData[12] = (byte) 1;
      } else if (module.equals("laptop")) {
      } else if(module.equals("curtains_enable")) {
        curtainsData[8] = (byte) (curtainsEnabled?1:0);
      } else if(module.equals("corners_enable")) {
        curtainsData[8] = (byte) (curtainsEnabled?1:0);
      }
    }

    void unPopulateData() {
      if (module.equals("scroll")) {
        scrollData[0] = (byte) 1;
        scrollData[1] = (byte) 0;
        scrollData[2] = (byte) (scrollDir?1:0);
      } else if (module.equals("curtains")) {
        //curtainsData[motorNr*3+0] = (byte) 1; //(curtainEnables[i]?1:0);
        curtainsData[motorNr*2+0] = (byte) 0;
        curtainsData[motorNr*2+1] = (byte) (curtainDirs[motorNr]?1:0);
        curtainsData[8] = (byte) 1;
      } else if (module.equals("corners")) {
        //cornersData[motorNr*3+0] = (byte) 1;
        cornersData[motorNr*2+0] = (byte) 0;
        cornersData[motorNr*2+1] = (byte) (cornerDirs[motorNr]?1:0);
        cornersData[8] = (byte) 1;
      } else if (module.equals("fans")) {
        cornersData[12] = (byte) 0;
      } else if (module.equals("leds")) {
      } else if (module.equals("turntables")) {
        //cornersData[motorNr*2+13] = (byte) 1;
        cornersData[motorNr+9] = (byte) 0;
        //cornersData[12] = (byte) 0;
      } else if (module.equals("laptop")) {
      } else if(module.equals("curtains_enable")) {
        //curtainsData[motorNr*3+0] = (byte) 1; //(curtainEnables[i]?1:0);
      }
    }

    void send() {
      
      if (module.equals("scroll")) {
        if(online) {
            try {
              artnet.unicastDmx(scrollIP, 0, 0, scrollData);
            }
            catch(Exception e) {
              println("scroll teensy down");
            }
        }
      } else if (module.equals("curtains")) {
          try {
            artnet.unicastDmx(curtainsIP, 0, 0, curtainsData);
            curtainsOutput.append(dataToString(curtainsData));
          }
          catch(Exception e) {
            println("curtains teensy down");
          }
        //printNicely("curtains", curtainsData);
      } else if (module.equals("corners")) {
          try {
            artnet.unicastDmx(cornersIP, 0, 0, cornersData);
            cornersOutput.append(dataToString(cornersData));
          }
          catch(Exception e) {
            println("corners teensy down");
          }
      } else if (module.equals("leds")) {
        //artnet.unicastDmx(ledsIP, 0, 0, ledsData[0]);
      } else if (module.equals("fans")) {
          try {
            artnet.unicastDmx(cornersIP, 0, 0, cornersData);
            cornersOutput.append(dataToString(cornersData));
          }
          catch(Exception e) {
            println("corners teensy down");
          }
      } else if (module.equals("turntables")) {
          try {
            artnet.unicastDmx(cornersIP, 0, 0, cornersData);
            cornersOutput.append(dataToString(cornersData));
          }
          catch(Exception e) {
            println("corners teensy down");
          }
      }
    }

    void setScrollParameters(int _vel, String _dir) {
      boolean dir = false;
      if (_dir.equals("up")) dir = false;
      else dir = true;
      scrollEnabled = true;
      scrollSpeed = _vel;
      scrollDir = dir;

      print(module + " " + timecode + " ");
      print(dataToString(scrollData));
      print(" " + map(_vel, 0, 100, 0, 255) + " vel ");
      println();
    }

    void setCurtainParameters(int m, int _vel, String _dir) {
      m--; // in json 1-4, als array muss das 0-3
      motorNr = m;
      boolean dir = false;
      if (_dir.equals("closing")) dir = false;
      else dir = true;
      //      curtainEnables[m] = true;
      curtainSpeeds[m] = _vel;
      curtainDirs[m] = dir;

      print(module + " " + timecode + " motorNr=" + motorNr);
      print(dataToString(curtainsData));
      //print(" " + map(_vel, 0, 100, 0, 255) + " vel ");
      print(" " + _vel + " vel ");
      println();
    }
    
    void setCurtainsEnable(boolean b) {
      if(b) {
        curtainsEnabled = true;
      } else {
        curtainsEnabled = false;
      }
    }

    void setCornersParameters(int m, int _vel, String _dir) {
      m--;
      motorNr = m;
      boolean dir = false;
      if (_dir.equals("pull")) dir = true;
      else dir = false;
      //cornerEnables[m] = true;
      cornerSpeeds[m] = _vel;
      cornerDirs[m] = dir;

      print(module + " " + timecode + " ");
      print(dataToString(cornersData));
      println();
    }

    void setFanParameters(boolean b) {
      fansEnable = b;
      print(module + " " + timecode + " ");
      print(dataToString(cornersData));
      println();
    }

    void setTurntableParameters(int m, boolean ena, int _vel) {
      // noch nicht fertig
      m--;
      motorNr = m;
      //turntableEnables[m] = true;
      turntableSpeeds[m] = _vel;
      print(module + " " + timecode + " ");
      print(dataToString(cornersData));
      println();
    }


    String dataToString(byte[] data) {
      String output = "{";
      for (int i = 0; i<data.length; i++) {
        output += str(data[i]) +", ";
      }
      output += "}";
      return output;
    }
  }
}
