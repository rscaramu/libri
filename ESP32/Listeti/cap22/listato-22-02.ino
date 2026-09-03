// ESP32 — La guida completa alla famiglia · capitolo 22 (USB)
// Listato 22.2 — Una scheda SD esposta come disco USB. Le due callback leggono e scrivono settori grezzi; il filesystem lo gestisce il computer.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <USB.h>
#include <USBMSC.h>
#include <SD.h>

USBMSC msc;

static int32_t onRead(uint32_t lba, uint32_t off, void *buf,
                      uint32_t n) {
  return SD.readRAW((uint8_t *)buf, lba) ? n : -1;
}
static int32_t onWrite(uint32_t lba, uint32_t off, uint8_t *buf,
                       uint32_t n) {
  return SD.writeRAW(buf, lba) ? n : -1;
}

void setup() {
  SD.begin(10);
  msc.vendorID("ESP32");
  msc.productID("SDcard");
  msc.onRead(onRead);
  msc.onWrite(onWrite);
  msc.mediaPresent(true);
  msc.begin(SD.numSectors(), SD.sectorSize());
  USB.begin();
}
