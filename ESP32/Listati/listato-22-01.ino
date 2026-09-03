// ESP32 — La guida completa alla famiglia · capitolo 22 (USB)
// Listato 22.1 — Una tastiera USB che scrive una frase alla pressione di BOOT. `USBHIDMouse`, `USBHIDGamepad` e `USBHIDConsumerControl` per i tasti multimediali seguono lo stesso schema.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <USB.h>
#include <USBHIDKeyboard.h>

USBHIDKeyboard tastiera;

void setup() {
  pinMode(0, INPUT_PULLUP);
  tastiera.begin();
  USB.begin();
}

void loop() {
  if (digitalRead(0) == LOW) {
    tastiera.print("ciao dal chip\n");
    delay(500);
  }
}
