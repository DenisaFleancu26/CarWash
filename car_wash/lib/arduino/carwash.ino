/*

#include <FirebaseArduino.h>
#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>

#define FIREBASE_HOST "xxxxxxxxxxxxxxxxxxxxxxxxx"
#define FIREBASE_AUTH "xxxxxxxxxxxx"
#define WIFI_SSID "xxxxxxx"
#define WIFI_PASSWORD "xxxxxxx"

#define CARWASH "SAwic2Ccc8ksnWWLOeMU"
#define SPOTS 2

// Define pins numbers for each sensor
int trigPins[SPOTS] = {D0, D2};  
int echoPins[SPOTS] = {D1, D5};  

// Define pins numbers for each LED
int ledGreen[SPOTS] = {D8, D6};
int ledRed[SPOTS] = {D4, D7};

// Defines variables
long durations[SPOTS];
int distances[SPOTS];

void setup() {

  Serial.begin(9600);

  for(int i=0; i< SPOTS; i++) {
    pinMode(trigPins[i], OUTPUT);
    pinMode(echoPins[i], INPUT);
    pinMode(ledRed[i], OUTPUT);
    pinMode(ledGreen[i], OUTPUT);
  }
  
  // Connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  // Connect to Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  for (int i = 0; i < SPOTS; i++) {


    if(Firebase.getInt(String(CARWASH) + "/spots/" + String(i+1) + "/broken") == 1)
    {
      digitalWrite(ledRed[i], LOW);
      digitalWrite(ledGreen[i], LOW);
    }else{
      // Clears the trigPin
      digitalWrite(trigPins[i], LOW);
      delayMicroseconds(2);

      // Sets the trigPin on HIGH state for 10 microseconds
      digitalWrite(trigPins[i], HIGH);
      delayMicroseconds(10);
      digitalWrite(trigPins[i], LOW);

      // Reads the echoPin, returns the sound wave travel time in microseconds
      durations[i] = pulseIn(echoPins[i], HIGH);

      if(durations[i] >= 0 && durations[i] <= 10000) 
      {
        distances[i] = durations[i] * 0.034 / 2; 
        if(distances[i] > 0 && distances[i] <= 10){
          digitalWrite(ledRed[i], HIGH);
          digitalWrite(ledGreen[i], LOW); 
          if(Firebase.getInt(String(CARWASH) + "/spots/" + String(i+1) + "/available") == 0)
          {
            Firebase.setInt(String(CARWASH) + "/spots/" + String(i+1) + "/available", 1);
          } 
        } else {
          digitalWrite(ledRed[i], LOW);
          digitalWrite(ledGreen[i], HIGH); 
          if(Firebase.getInt(String(CARWASH) + "/spots/" + String(i+1) + "/available") == 1)
          {
            Firebase.setInt(String(CARWASH) + "/spots/" + String(i+1) + "/available", 0);
          } 
        }
      }
    }
  }
  delay(1000);
}

*/