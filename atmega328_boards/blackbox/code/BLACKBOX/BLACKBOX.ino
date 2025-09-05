#include <SPI.h>
#include <SD.h>

File myFile;
const int chipSelect = 10;

void setup() {
  Serial.begin(9600);

  if (!SD.begin(chipSelect)) {     
    Serial.println("SD Card initialization failed!");
    return;
  }
  Serial.println("SD Card initialized.");
}

void loop() {
  if (Serial.available() > 0) {
    String receivedData = Serial.readStringUntil('\n');
    myFile = SD.open("data_log.csv", FILE_WRITE);
    if (myFile) {
      myFile.println(receivedData);
      myFile.close();
    } else {
      Serial.println("Error opening data_log.csv");
    }
  }
}
