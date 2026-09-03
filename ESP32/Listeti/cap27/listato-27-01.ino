// ESP32 — La guida completa alla famiglia · capitolo 27 (Bluetooth)
// Listato 27.1 — Un ponte seriale Bluetooth sull'ESP32 classico. Da Android, qualunque app di terminale Bluetooth lo vede.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <BluetoothSerial.h>
BluetoothSerial bt;

void setup() {
  Serial.begin(115200);
  bt.begin("ESP32-Seriale");
}

void loop() {
  if (bt.available()) Serial.write(bt.read());
  if (Serial.available()) bt.write(Serial.read());
}
