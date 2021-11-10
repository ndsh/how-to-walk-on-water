class JSONParser {
  JSONArray data;
  String filename = "";
  
  public JSONParser(String s) {
    //println(s);
    data = new JSONArray();
    data = loadJSONArray(s);
    println("Parser: Created parser for file=" + s);
    filename = s;
  }  
  
  JSONObject getObject(JSONArray j, int i) {
    return j.getJSONObject(i);
  }
  
  JSONArray getArray(JSONObject j, String s) {
    return j.getJSONArray(s);
  }
  
  void setData(JSONArray j) {
    data = j;
  }
   
  JSONArray getData() {
    return data;
  }
  
  int getDumpLength() {
    return data.size();
  }
  
  void dump() {
    println("Parser: Dumping data for= " + filename);
    printArray(data);
  }
}
