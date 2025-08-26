#include "arduino_secrets.h"

#include "Arduino.h"
#include "uRTCLib.h"
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <dht.h>  
#include "gasses.h"

// Temp/humidity
#define outPin 8
// OLED
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
#define SCREEN_ADDRESS 0x3C
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
// Gas sensor
#define Threshold 400
#define MQ2pin 0
dht DHT;
uRTCLib rtc(0x68);
int sensorValue;

char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

void setup() {
  Serial.begin(9600);
  rtc.set(0, 56, 12, 2, 14, 4, 25);

  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;);
  }

  display.clearDisplay();
  display.setCursor(0, 28);
  display.println("Warming gas sensor, please wait");
  display.display();
  delay(20000);
}

void loop() {
  display.clearDisplay();

  int readData = DHT.read11(outPin);
  sensorValue = analogRead(MQ2pin);

  if (sensorValue > Threshold) {
    display.clearDisplay();
    display.drawBitmap(0, 0, gasses.gas1(), 128, 64, WHITE);
    display.display();
    delay(500);
    display.clearDisplay();
    display.drawBitmap(0, 0, gasses.gas2(), 128, 64, WHITE);
    display.display();
    delay(500);
  }

  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);

  display.setCursor(0, 0);
  display.print("Temp: ");
  display.print((DHT.temperature * 9.0 / 5.0) + 32.0);
  display.println((char)247); // Degree symbol
  display.println("F");

  display.setCursor(0, 16);
  display.print("Humidity: ");
  display.print(DHT.humidity);
  display.println("%");

  display.setCursor(0, 32);
  display.print("Time: ");
  display.print(rtc.hour());
  display.print(":");
  display.print(rtc.minute());
  display.print(":");
  display.println(rtc.second());

  display.setCursor(0, 48);
  display.print("Date: ");
  display.print(rtc.day());
  display.print("/");
  display.print(rtc.month());
  display.print("/");
  display.println(rtc.year());

  display.display();
  delay(1000);
}
