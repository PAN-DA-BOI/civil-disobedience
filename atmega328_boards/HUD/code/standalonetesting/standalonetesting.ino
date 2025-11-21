#include <dht.h>


//MQ2 GAS-SENSOR = A0
#define MQ2pin 0

//buzzer = D6
const int buzzer = 6;

//DHT-11 = D8
#define dataPin 8

dht DHT;
float sensorValue;




void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);  // sets the serial port to 9600
  Serial.println("MQ2 warming up!");
  delay(20000);

}

void loop() {
  // put your main code here, to run repeatedly:

}
