#include <Arduino.h>
#include <Capacitor.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "mate40pro"
#define WIFI_PASSWORD "88888888"

// Insert Firebase project API Key
#define API_KEY "AIzaSyC6RpgiJq4_0dBQ9bCBSi5CKQAyh_7mvz0"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://water-reminder-e82b1-default-rtdb.europe-west1.firebasedatabase.app/" 

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;


/////water
Capacitor cap1(7,A2);
int kondenzator=0;
int w = 0;
/////
void setup(){
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  // else{
  //   Serial.print("%s\n", config.signer.signupError.message.c_str());
  // }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop(){
  // if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)){
  //   sendDataPrevMillis = millis();
  //   // Write an Int number on the database path test/int
  //   if (Firebase.RTDB.setInt(&fbdo, "test/int", count)){
  //     Serial.println("PASSED");
  //     Serial.println("PATH: " + fbdo.dataPath());
  //     Serial.println("TYPE: " + fbdo.dataType());
  //   }
  //   else {
  //     Serial.println("FAILED");
  //     Serial.println("REASON: " + fbdo.errorReason());
  //   }
  //   count++;
    
  //   // Write an Float number on the database path test/float
  //   if (Firebase.RTDB.setFloat(&fbdo, "test/float", 0.01 + random(0,100))){
  //     Serial.println("PASSED");
  //     Serial.println("PATH: " + fbdo.dataPath());
  //     Serial.println("TYPE: " + fbdo.dataType());
  //   }
  //   else {
  //     Serial.println("FAILED");
  //     Serial.println("REASON: " + fbdo.errorReason());
  //   }
  // }

    //kondenzator = (cap1.Measure())*100;
  kondenzator = cap1.Measure();
  //Serial.println(kondenzator);  // Measure the capacitance (in pF), print to Serial Monitor
  int w = map(kondenzator, 95, 643, 0, 320); 
  Serial.println(w);
  if (Firebase.ready() && signupOK){
    if (Firebase.RTDB.setInt(&fbdo, "test/int", w)){
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }
  delay(10000);
}
