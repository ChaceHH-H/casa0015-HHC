#include <WiFi.h>
#include <HTTPClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <TimeLib.h>
// NTP server
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");


const char* ssid = "mate40pro";     
const char* password = "88888888"; 

// Firestore API 
const char* projectID = "fir-flutter-codelab-a80ae"; //Project ID
const char* collection = "water-history"; // Collection name
int buttonState = 0;//button
void setup() {
  Serial.begin(115200);

  //Connect to wifi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected to WiFi");
  timeClient.begin();

  //button
  pinMode(9,INPUT);
}

void loop() {
  buttonState = digitalRead(9);
  if (buttonState == HIGH) {
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
    int waterLevel = analogRead(A0); // Water level sensor
    String jsonData = "{\"fields\": {\"date\": {\"timestampValue\": \"" + String(dateTimeStr) + "\"}, \"watervalue\": {\"integerValue\": \"" + String(waterLevel) + "\"}}}";

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

}

bool isDST(int day, int month, int weekday) {
    if (month < 3 || month > 10) return false; 
    if (month > 3 && month < 10) return true; 
    int previousSunday = day - weekday;
    if (month == 3) return previousSunday >= 25;
    if (month == 10) return previousSunday < 25;
    return false; 
}