void setup() {
  size(400, 400);
}

void draw() {
  println("bonour");
  println(isOnline());
}

public boolean isOnline() {
  Runtime runtime = Runtime.getRuntime();
  
  try {
    Process ipProcess = runtime.exec("ping  2.0.0.2");
    int     exitValue = ipProcess.waitFor();
    return (exitValue == 0);
  }
  
  catch (IOException e) { 
    e.printStackTrace();
  }
  
  catch (InterruptedException e) { 
    e.printStackTrace();
  } return false;
}
