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

    void setScrollParameters(int ena, int vel, int dir) {
      
    }
    
    

	}

}
