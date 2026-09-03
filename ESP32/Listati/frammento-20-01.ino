// ESP32 — La guida completa alla famiglia · capitolo 20 (I2C, SPI, UART, TWAI)
// Frammento — I2C
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <Wire.h>

void setup() {
  Serial.begin(115200);
  Wire.begin(21, 22);          // SDA, SCL
  Wire.setClock(400000);
  Wire.setTimeOut(50);         // ms, contro i bus bloccati
}
