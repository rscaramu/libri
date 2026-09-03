// ESP32 — La guida completa alla famiglia · capitolo 20 (I2C, SPI, UART, TWAI)
// Listato 20.2 — Una lettura SPI con un bus secondario e CS gestito a mano. `beginTransaction` fissa velocità, ordine dei bit e modo, e blocca il bus contro altri task.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <SPI.h>

SPIClass spi(HSPI);             // secondo bus, se il primo è occupato

void setup() {
  spi.begin(14, 12, 13, 15);    // SCK, MISO, MOSI, SS
  pinMode(15, OUTPUT);
}

uint8_t leggiRegistro(uint8_t reg) {
  spi.beginTransaction(SPISettings(10000000, MSBFIRST, SPI_MODE0));
  digitalWrite(15, LOW);
  spi.transfer(reg | 0x80);
  uint8_t v = spi.transfer(0x00);
  digitalWrite(15, HIGH);
  spi.endTransaction();
  return v;
}
