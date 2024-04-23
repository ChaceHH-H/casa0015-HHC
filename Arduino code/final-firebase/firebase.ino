#include <WiFi.h>
#include <HTTPClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <TimeLib.h>
#include <Wire.h>
#ifdef ARDUINO_SAMD_VARIANT_COMPLIANCE
#define SERIAL SerialUSB
#else
#define SERIAL Serial
#endif
unsigned char low_data[8] = {0};
unsigned char high_data[12] = {0};
#define NO_TOUCH       0xFE
#define THRESHOLD      100
#define ATTINY1_HIGH_ADDR   0x78
#define ATTINY2_LOW_ADDR   0x77


int watervalue1111;
int watervalue2222;
int watervalue3333;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");


const char* ssid = "mate40pro";     
const char* password = "88888888"; 

// Firestore API 
const char* projectID = "fir-flutter-codelab-a80ae"; //Project ID
const char* collection = "water-history"; // Collection name
int buttonState = 0;//button

/////////////////////
void getHigh12SectionValue(void)
{
  memset(high_data, 0, sizeof(high_data));
  Wire.requestFrom(ATTINY1_HIGH_ADDR, 12);
  while (12 != Wire.available());

  for (int i = 0; i < 12; i++) {
    high_data[i] = Wire.read();
  }
  delay(10);
}

void getLow8SectionValue(void)
{
  memset(low_data, 0, sizeof(low_data));
  Wire.requestFrom(ATTINY2_LOW_ADDR, 8);
  while (8 != Wire.available());

  for (int i = 0; i < 8 ; i++) {
    low_data[i] = Wire.read(); // receive a byte as character
  }
  delay(10);
}

void check()
{
  int sensorvalue_min = 250;
  int sensorvalue_max = 255;
  int low_count = 0;
  int high_count = 0;
  //while (1)
  //{
    uint32_t touch_val = 0;
    uint8_t trig_section = 0;
    low_count = 0;
    high_count = 0;
    getLow8SectionValue();
    getHigh12SectionValue();

    Serial.println("low 8 sections value = ");
    for (int i = 0; i < 8; i++)
    {
      Serial.print(low_data[i]);
      Serial.print(".");
      if (low_data[i] >= sensorvalue_min && low_data[i] <= sensorvalue_max)
      {
        low_count++;
      }
      if (low_count == 8)
      {
        Serial.print("      ");
        Serial.print("PASS");
      }
    }
    Serial.println("  ");
    Serial.println("  ");
    Serial.println("high 12 sections value = ");
    for (int i = 0; i < 12; i++)
    {
      Serial.print(high_data[i]);
      Serial.print(".");

      if (high_data[i] >= sensorvalue_min && high_data[i] <= sensorvalue_max)
      {
        high_count++;
      }
      if (high_count == 12)
      {
        Serial.print("      ");
        Serial.print("PASS");
      }
    }

    Serial.println("  ");
    Serial.println("  ");

    for (int i = 0 ; i < 8; i++) {
      if (low_data[i] > THRESHOLD) {
        touch_val |= 1 << i;

      }
    }
    for (int i = 0 ; i < 12; i++) {
      if (high_data[i] > THRESHOLD) {
        touch_val |= (uint32_t)1 << (8 + i);
      }
    }

    while (touch_val & 0x01)
    {
      trig_section++;
      touch_val >>= 1;
    }
    SERIAL.print("water level = ");
    SERIAL.print(trig_section * 5);
    watervalue1111 = map(trig_section, 0, 18, 0, 250);
    SERIAL.println("% ");
    SERIAL.println(watervalue1111);
    SERIAL.println("*********************************************************");
    //delay(1000);
  //}
}
////////////////////////////////

void setup() {
  Serial.begin(9600);
  Wire.begin();
  //Connect to wifi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected to WiFi");
  timeClient.begin();

  //button
  pinMode(10,INPUT);
}

void loop() {
  buttonState = digitalRead(10);
  if (buttonState == HIGH) {
    check();
    watervalue2222=watervalue1111;
    delay(10000);
    check();
    watervalue2222 -= watervalue1111;
   if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    timeClient.update();

    unsigned long epochTime = timeClient.getEpochTime();
    setTime(epochTime);

    // Check if it is during daylight saving time
    int timeOffset = 0;
    if (isDST(day(), month(), weekday())) {
      timeOffset = 3600;  // UTC +1 
    }
    timeClient.setTimeOffset(timeOffset);

    char dateTimeStr[25];
    sprintf(dateTimeStr, "%04d-%02d-%02dT%02d:%02d:%02dZ", year(), month(), day(), hour(), minute(), second());

    // Building a REST API URL for Firestore
    String url = "https://firestore.googleapis.com/v1/projects/" + String(projectID) + "/databases/(default)/documents/" + String(collection) + "?key=YOUR_API_KEY";

    // Build JSON data

    delay(200);
    String jsonData = "{\"fields\": {\"date\": {\"timestampValue\": \"" + String(dateTimeStr) + "\"}, \"watervalue\": {\"integerValue\": \"" + String(watervalue2222) + "\"}}}";

    http.begin(url);
    http.addHeader("Content-Type", "application/json");
    int httpResponseCode = http.POST(jsonData);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      Serial.print("Response: ");
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  }
  }
  watervalue2222=0;
  //delay(3000);

}

bool isDST(int day, int month, int weekday) {
    if (month < 3 || month > 10) return false; 
    if (month > 3 && month < 10) return true; 
    int previousSunday = day - weekday;
    if (month == 3) return previousSunday >= 25;
    if (month == 10) return previousSunday < 25;
    return false; 
}