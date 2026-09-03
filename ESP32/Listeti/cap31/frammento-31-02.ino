// ESP32 — La guida completa alla famiglia · capitolo 31 (Storage)
// Frammento — Scheda SD
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <SD.h>
#include <SPI.h>

SPIClass spiSD(HSPI);

void setup() {
  spiSD.begin(14, 12, 13, 15);
  if (!SD.begin(15, spiSD, 20000000)) {
    Serial.println("SD assente o non leggibile");
    return;
  }
  Serial.printf("SD: %llu MB\n", SD.cardSize() / (1024 * 1024));
}
