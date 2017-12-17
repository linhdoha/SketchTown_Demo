#include <Keyboard.h>

int buttonPin = 2;

void setup() {
  pinMode(buttonPin, INPUT);
  Keyboard.begin();
}

void loop() {
  if (digitalRead(buttonPin) == 1) {
    Keyboard.write(' ');
    delay(100);
  }
}
//
