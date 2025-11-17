const int button = 4;
const int ledPin = LED_BUILTIN;

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(button, INPUT_PULLUP);
}

void loop() {
  int buttonState = digitalRead(button);

  if (buttonState == LOW) {
    digitalWrite(ledPin, HIGH); 
      } else {
    digitalWrite(ledPin, LOW);
  }
}
