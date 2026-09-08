// listato 22.4 — Nano 33 BLE: modello negli ultimi 128 KB di Flash (FlashIAP), aggiornamento via BLE a blocchi
#include <ArduinoBLE.h>
#include <FlashIAP.h>
mbed::FlashIAP flash;
const uint32_t BASE_A = 0xE0000, BASE_B = 0xF0000, DIM = 0x10000;
uint32_t baseLibera = BASE_B, off = 0;
BLEService servizio("19B10000-E8F2-537E-4F6C-D104768A1214");
BLECharacteristic blocco("19B10002-E8F2-537E-4F6C-D104768A1214", BLEWrite, 200);
BLEByteCharacteristic comando("19B10003-E8F2-537E-4F6C-D104768A1214", BLEWrite);

void onComando(BLEDevice, BLECharacteristic c) {
  uint8_t v = c.value()[0];
  if (v == 1) { flash.erase(baseLibera, DIM); off = 0; }
  if (v == 2) { Serial.println("fine: verifica, attiva, riavvia"); /* verifica come nel listato 22.2 */ }
}
void onBlocco(BLEDevice, BLECharacteristic c) {
  int n = c.valueLength(); uint8_t buf[200]; memcpy(buf, c.value(), n);
  while (n % 4) buf[n++] = 0xFF;                       // la Flash del nRF52 si scrive a parole
  flash.program(buf, baseLibera + off, n); off += n;
}
void setup() {
  Serial.begin(115200);
  flash.init();
  if (!BLE.begin()) while (1);
  BLE.setLocalName("Cadute"); BLE.setAdvertisedService(servizio);
  servizio.addCharacteristic(blocco); servizio.addCharacteristic(comando); BLE.addService(servizio);
  blocco.setEventHandler(BLEWritten, onBlocco); comando.setEventHandler(BLEWritten, onComando);
  BLE.advertise();
  Serial.print("modello A a 0x"); Serial.println(BASE_A, HEX);
}
void loop() { BLE.poll(); }
