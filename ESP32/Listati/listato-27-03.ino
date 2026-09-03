// ESP32 — La guida completa alla famiglia · capitolo 27 (Bluetooth)
// Listato 27.3 — Una scansione continua che stampa ogni dispositivo visto. I dati di servizio nell'advertising contengono, per molti sensori, la misura in chiaro o cifrata con una chiave nota.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <NimBLEDevice.h>

class Scan : public NimBLEScanCallbacks {
  void onResult(const NimBLEAdvertisedDevice *d) override {
    Serial.printf("%s  %d dBm  %s\n",
                  d->getAddress().toString().c_str(),
                  d->getRSSI(), d->getName().c_str());
    if (d->haveServiceData()) {
      std::string sd = d->getServiceData(0);
      // decodifica del formato specifico del sensore
    }
  }
};

void setup() {
  Serial.begin(115200);
  NimBLEDevice::init("");
  NimBLEScan *s = NimBLEDevice::getScan();
  s->setScanCallbacks(new Scan());
  s->setActiveScan(true);
  s->setInterval(100);
  s->setWindow(99);
  s->start(0, false);         // 0 = per sempre
}

void loop() { delay(1000); }
