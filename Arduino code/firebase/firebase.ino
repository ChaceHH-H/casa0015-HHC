#include <WiFi.h>
#include <HTTPClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <TimeLib.h>
// NTP 服务器
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");


const char* ssid = "mate40pro";     // 你的 WiFi 名称
const char* password = "88888888"; // 你的 WiFi 密码

// Firestore API 需要的是你的项目ID
const char* projectID = "fir-flutter-codelab-a80ae";
const char* collection = "water-history"; // Firestore 集合名

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected to WiFi");

  timeClient.begin();
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    timeClient.update();

    unsigned long epochTime = timeClient.getEpochTime();
    setTime(epochTime);

    // 检查是否为夏令时期间
    int timeOffset = 0;
    if (isDST(day(), month(), weekday())) {
      timeOffset = 3600;  // UTC +1 小时
    }
    timeClient.setTimeOffset(timeOffset);

    char dateTimeStr[25];
    sprintf(dateTimeStr, "%04d-%02d-%02dT%02d:%02d:%02dZ", year(), month(), day(), hour(), minute(), second());

    // 构建 Firestore 的 REST API URL
    String url = "https://firestore.googleapis.com/v1/projects/" + String(projectID) + "/databases/(default)/documents/" + String(collection) + "?key=YOUR_API_KEY";

    // 构建 JSON 数据
    int waterLevel = analogRead(A0); // 假设水位传感器连接到 A0
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

  delay(10000); // 每10秒发送一次数据
}

bool isDST(int day, int month, int weekday) {
    // 英国夏令时从三月最后一个周日开始到十月最后一个周日结束
    if (month < 3 || month > 10) return false; // 一月, 二月, 十一月和十二月
    if (month > 3 && month < 10) return true; // 四月到九月

    int previousSunday = day - weekday;

    // 在三月，我们在最后一个周日过后是夏令时
    if (month == 3) return previousSunday >= 25;
    // 在十月，我们在最后一个周日之前仍然是夏令时
    if (month == 10) return previousSunday < 25;

    return false; // 应该不会发生
}