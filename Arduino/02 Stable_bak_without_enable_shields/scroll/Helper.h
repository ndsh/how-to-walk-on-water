// Include libraries


//#include <Ethernet.h>
//#include <EthernetUdp.h>
#include <NativeEthernet.h>
#include <NativeEthernetUdp.h>
#define UDP_TX_PACKET_MAX_SIZE 512 //increase UDP size
#include <Artnet.h>
#include <SPI.h>

// Pin definitions
#define RESET_PIN 12
int driverPUL = 9;      // PUL- pin
int driverDIR = 10;     // DIR- pin
int driverENA = 11;


// Variables

// Read-only
const bool debug = false;

// Globals
boolean shieldAvailable = true;
boolean networkDataAvailable = false;
boolean linkEthernetStatus = false;
long millisRecheckNetwork = 0;
long millisKeepAlive = 0;
long delayNetworkCheck = 1000; // 10 sekunden ist auch okay, aber dauert lange zum reconnecten
byte ip[] = {2, 0, 0, 2};
byte broadcast[] = {2, 0, 0, 255}; // eigene ip
byte mac[] = {0x04, 0xE9, 0xE5, 0x00, 0x69, 0xEC};
uint16_t r;
boolean showStateTitle = false;
int prevState = 0;
byte dataPackage[32];
int pos = 0;
int u = 0;

int pd = 500;           // Pulse Delay period
boolean setdir = LOW;   // Set Direction

// Millis Area
long millisLastTransmission = 0;
long delayTransmission = 0;
boolean dotsSwitcherState = false;

long millisEthernetStatusLink = 0;
long millisEthernetStatusDelay = 1000;
//int currentState = 0;

boolean validData = false;

// Objects
Artnet artnet;

// Arrays
                                         
// Functions
float mapfloat(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void pin_reset() {
  #ifdef TEENSYDUINO
   SCB_AIRCR = 0x05FA0004;
  #endif
}

void setupEnv() {
  Serial.begin(115200);
  //while (!Serial) ; // wait for serial port to connect. Needed for native USB port only

  Serial.println("/ / / / / / / / / / / / / / / / / / / / /");
  Serial.println("→ Setup");
  Serial.println("Artnet Control for Arduino is starting");
  Serial.println();
  Serial.println("Software: https://github.com/ndsh/how-to-walk-on-water");


  // initialize sub-routines  
  artnet.begin(mac, ip);
  //artnet.setBroadcast(broadcast);

  attachInterrupt(RESET_PIN, pin_reset, FALLING);
  pinMode (driverPUL, OUTPUT);
  pinMode (driverDIR, OUTPUT);
  pinMode (driverENA, OUTPUT);
  digitalWrite(driverENA, LOW);
  digitalWrite(LED_BUILTIN, HIGH);
  
  Serial.println("/ / / / / / / / / / / / / / / / / / / / /");
  Serial.println();
}

boolean checkEthernetLinkStatus() {
  linkEthernetStatus = true;
  /*
  if (Ethernet.hardwareStatus() == EthernetNoHardware) {
      Serial.println("Ethernet shield was not found.");
      linkEthernetStatus = false;
    }
  if (Ethernet.linkStatus() == LinkOFF) {
      Serial.println("Ethernet cable is not connected.");
      linkEthernetStatus = false;
  }
  */
  return linkEthernetStatus;
}
