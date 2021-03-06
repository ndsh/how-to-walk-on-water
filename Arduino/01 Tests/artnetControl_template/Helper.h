// Include libraries


//#include <Ethernet.h>
//#include <EthernetUdp.h>
#include <NativeEthernet.h>
#include <NativeEthernetUdp.h>
#define UDP_TX_PACKET_MAX_SIZE 512 //increase UDP size
#include <Artnet.h>
#include <SPI.h>

// Pin definitions
#define LED_PIN 6 //30
#define RESET_PIN 12
#define NUM_STRIPS 1

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

// Millis Area
long millisLastTransmission = 0;
long delayTransmission = 0;
boolean dotsSwitcherState = false;

int idlePixel = 0;
boolean idleDirection = true;
int idleBrightness = 0;
int maxIdleBrightness = 50;

long millisEthernetStatusLink = 0;
long millisEthernetStatusDelay = 1000;
//int currentState = 0;


// Objects
//CRGB leds[NUMPIXELS];
//Adafruit_NeoPixel pixels(NUMPIXELS, LED_PIN, NEO_GRB + NEO_KHZ800);
Artnet artnet;

// Arrays

// Temporär für Flipdigits
byte count = 0;
byte maximum = 127;
byte header[]= {0x80, 0x83};
byte header_norefresh[]= {0x80, 0x84};
byte header_refresh[]= {0x80, 0x82};
byte address13[] = {0x0D}; // panel 13
byte address14[] = {0x0E}; // panel 14
byte closure[]= {0x8F};
byte all_bright_2C[]= {0x80, 0x83, 0xFF, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x8F};
byte all_dark_2C[]=   {0x80, 0x83, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8F};
byte mix_2C[]=        {0x80, 0x83, 0x0E, 0x06, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x8F};
byte f[]= {0x80, 0x89, 0xFF, 0x02, 0x8F};
byte e[]= {0x80, 0x89, 0xFF, 0x4F, 0x8F};
                                         
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

boolean checkEthernetLinkStatus_OLD() {
  linkEthernetStatus = false;
  /*
  if (Ethernet.linkStatus() == Unknown) {
      Serial.println("Link status unknown. Link status detection is only available with W5200 and W5500.");
    }
    else if (Ethernet.linkStatus() == LinkON) {
      //Serial.println("Link status: On");
      linkEthernetStatus = true;
    }
    else if (Ethernet.linkStatus() == LinkOFF) {
      //Serial.println("Link status: Off");
      linkEthernetStatus = false;
    }
    */
    return linkEthernetStatus;
}
