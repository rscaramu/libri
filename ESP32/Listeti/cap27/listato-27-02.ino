// ESP32 — La guida completa alla famiglia · capitolo 27 (Bluetooth)
// Listato 27.2 — Un server con il servizio standard *Environmental Sensing*: le app generiche mostrano la temperatura senza configurazione. La lettura richiede cifratura e il pairing con passkey.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <NimBLEDevice.h>

#define SVC_UUID  "181A"     // Environmental Sensing, standard
#define CHR_UUID  "2A6E"     // Temperature, standard, 0,01 °C

NimBLECharacteristic *chrTemp;

class Srv : public NimBLEServerCallbacks {
  void onConnect(NimBLEServer *s, NimBLEConnInfo &c) override {
    NimBLEDevice::startAdvertising();   // resta scopribile
  }
};

void setup() {
  NimBLEDevice::init("Sensore-C6");
  NimBLEDevice::setSecurityAuth(true, true, true); // bond, MITM, SC
  NimBLEDevice::setSecurityPasskey(123456);
  NimBLEDevice::setSecurityIOCap(BLE_HS_IO_DISPLAY_ONLY);

  NimBLEServer *srv = NimBLEDevice::createServer();
  srv->setCallbacks(new Srv());
  NimBLEService *svc = srv->createService(SVC_UUID);
  chrTemp = svc->createCharacteristic(CHR_UUID,
      NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY |
      NIMBLE_PROPERTY::READ_ENC);
  svc->start();

  NimBLEAdvertising *adv = NimBLEDevice::getAdvertising();
  adv->addServiceUUID(SVC_UUID);
  adv->start();
}

void loop() {
  int16_t t = (int16_t)(leggiTemperatura() * 100);
  chrTemp->setValue((uint8_t *)&t, 2);
  chrTemp->notify();
  delay(2000);
}
