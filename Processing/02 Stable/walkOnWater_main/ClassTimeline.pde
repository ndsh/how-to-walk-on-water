// Class to run the media show
// Here we combine bunch of the other classes to route the pixels where we want them to go
// This class can or should only be started by Organizer or the StateMachine and finishes cleanly at one point
// cleanly = all
// what states of timeliner are needed to communicate to the outside world that we are: ready, hasFinished or started?
// can these states be summed up?

// We need to load the timeline.json
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
		for(int i = 0; i<chunks.size(); i++) {
			chunks.get(i).init();
		}
	}

	void go() {
		if(isReady) {
			go = true;
			startTime = millis();
			isReady = false;
		} else {
			println("Timeline has not been readied yet.");
		}
		
	}

	void update() {
		if(go) {
  
			delta = millis()-startTime;
			//push();
			//fill(255);
			//if(delta % 30000 == 0) println("--> Elapsed delta time= " + ((delta/1000)/60) +":"+ ((delta/1000)/60));
			//pop();

			for(int i = 0; i<chunks.size(); i++) {
				chunks.get(i).update();
			}
			isFinished();
			if(isFinished) go = false;
		}
	}

	boolean isFinished() {
		for(int i = 0; i<chunks.size(); i++) {
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

		boolean finished = false;
    boolean executeUDPonce = false;
    boolean executeCasambiOnce = false;
    
    byte[] scrollData = new byte[4];
    byte[] curtainsData = new byte[12];
    byte[] cornersData = new byte[20];
    byte[][] ledsData = new byte[4][240]; // 4 universe each 240 LEDs
    
    boolean scrollEnabled = true;
    int sliderScrollSpeed = 125;
    boolean scrollDir = false;
    
    boolean[] curtainEnables = {true, true, true, true};
    int[] curtainSpeeds = {0, 0, 0, 0};
    boolean[] curtainDirs = {true, true, true, true};
    
    boolean[] cornerEnables = {true, true, true, true};
    int[] cornerSpeeds = {0, 0, 0, 0};
    boolean[] cornerDirs = {true, true, true, true};
    
    boolean[] turntableEnables = {true, true, true, true};
    int[] turntableSpeeds = {125, 125, 125, 125};
    
    boolean fansEnable = false;
    boolean desktopLED = false;
    

		public Chunk(long time, long _duration, String _message, String _module) {
			timecode = time;
      println(timecode);
			duration = _duration;
			message = _message;    
      module = _module;
      
		}

		void update() {
			if(delta >= timecode && (delta <= timecode+duration)) {
        println(timecode + " / " + module);
        /*
        if(udp_trigger.length() > 0) {
          
          if(!executeUDPonce) {
            println("hallo udp=");
            executeUDPonce = true;
            println(udp_device);
            if(udp_device.equals("konterwand")) {
              println("konterwand udp");
              communicator.send("black", konterwandIP, konterwandPort);
              communicator.send(udp_trigger, konterwandIP, konterwandPort);
            } else if(udp_device.equals("vitrine")) {
              println("vitrine udp");
              communicator.send("black", vitrineIP, vitrinePort);
              communicator.send(udp_trigger, vitrineIP, vitrinePort);
            }        
          }
        }
        */
        
        
        
				// this chunk runs after its starttime and only for the duration
				// no other calculations for now
				//println(message +" "+ delta);

				// do stuff here
        /*
				push();
				noStroke();
				fill(duration % 255);
				ellipse(duration/100, duration/100, 20, 20);
				pop();
        */
        populateData();
        send();
        
			} else if(delta > timecode+duration) {
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
      if(module.equals("scroll")) {
      } else if(module.equals("curtains")) {
        for(int i = 0; i<4; i++) {
          println(i*3+0);
          println(i*3+1);
          println(i*3+2);
          curtainsData[i*3+0] = (byte) 1; //(curtainEnables[i]?1:0);
          curtainsData[i*3+1] = (byte) curtainSpeeds[i];
          curtainsData[i*3+2] = (byte) (curtainDirs[i]?1:0);
        }
        
      } else if(module.equals("corners")) {
        for(int i = 0; i<4; i++) {
          println(i*3+0);
          println(i*3+1);
          println(i*3+2);
          cornersData[i*3+0] = (byte) 1; //(cornerEnables[i]?1:0);
          cornersData[i*3+1] = (byte) cornerSpeeds[i];
          cornersData[i*3+2] = (byte) (cornerDirs[i]?1:0);
        }
      } else if(module.equals("leds")) {
      }
    }

    void send() {
      if(!online) return;
      if(module.equals("scroll")) {
        artnet.unicastDmx(scrollIP, 0, 0, scrollData);
      } else if(module.equals("curtains")) {
        artnet.unicastDmx(curtainsIP, 0, 0, curtainsData);
      } else if(module.equals("corners")) {
        artnet.unicastDmx(cornersIP, 0, 0, cornersData);
      } else if(module.equals("leds")) {
        //artnet.unicastDmx(ledsIP, 0, 0, ledsData[0]);
      }
    }

    void setScrollParameters(int _vel, String _dir) {
      boolean dir = false;
      if(_dir.equals("up")) dir = true;
      else dir = false;
      scrollData[0] = (byte) 1;
      scrollData[1] = (byte) map(_vel, 0, 100, 0, 255);
      scrollData[2] = (byte) (dir?1:0);
    }
    
    void setCurtainParameters(int m, int _vel, String _dir) {
      m--; // in json 1-4, als array muss das 0-3
      boolean dir = false;
      if(_dir.equals("left")) dir = true;
      else dir = false;
      // alle anderen parameter auf 0 setzen
      for(int i = 0; i<12; i++) curtainsData[i] = 0;
      curtainsData[m*3+0] = (byte) 1; //(curtainEnables[i]?1:0);
      curtainsData[m*3+1] = (byte) map(_vel, 0, 100, 0, 255); // conversion from 0-10 to the 0-255 range
      curtainsData[m*3+2] = (byte) (dir?1:0);
    }
    
    void setCornersParameters(int m, int _vel, String _dir) {
      m--;
      boolean dir = false;
      if(_dir.equals("pull")) dir = true;
      else dir = false;
      // alle anderen parameter auf 0 setzen
      for(int i = 0; i<20; i++) cornersData[i] = 0;
      cornersData[m*3+0] = (byte) 1; //(curtainEnables[i]?1:0);
      cornersData[m*3+1] = (byte) map(_vel, 0, 100, 0, 255); // conversion from 0-10 to the 0-255 range
      cornersData[m*3+2] = (byte) (dir?1:0);
    }   
    
    void setFanParameters(boolean b) {
      // alle anderen parameter auf 0 setzen
      for(int i = 0; i<20; i++) cornersData[i] = 0;
      cornersData[12] = (byte) (b?1:0);
    }
    
    void setTurntableParameters(int m, boolean ena, int _vel) {
      // noch nicht fertig
      /*
      m--;
      boolean dir = false;
      if(_dir.equals("pull")) dir = true;
      else dir = false;
      // alle anderen parameter auf 0 setzen
      for(int i = 0; i<20; i++) cornersData[i] = 0;
      cornersData[((m*2)+0)+13] = (byte) 1; //(curtainEnables[i]?1:0);
      cornersData[m*3+1] = (byte) map(_vel, 0, 100, 0, 255); // conversion from 0-10 to the 0-255 range
      cornersData[m*3+2] = (byte) (dir?1:0);
      */
    } 

	}

}
