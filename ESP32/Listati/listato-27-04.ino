// ESP32 — La guida completa alla famiglia · capitolo 27 (Bluetooth)
// Listato 27.4 — Un client che si connette al server del listato 27.2 e si abbona alle notifiche. La connessione resta aperta finché non si chiama `disconnect()`.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

void onNotifica(NimBLERemoteCharacteristic *c, uint8_t *d,
                size_t n, bool isNotify) {
  int16_t t; memcpy(&t, d, 2);
  Serial.printf("temperatura %.2f\n", t / 100.0f);
}

bool leggiSensore(NimBLEAddress addr) {
  NimBLEClient *cl = NimBLEDevice::createClient();
  cl->setConnectTimeout(5000);
  if (!cl->connect(addr)) return false;
  NimBLERemoteService *svc = cl->getService("181A");
  NimBLERemoteCharacteristic *ch = svc ?
      svc->getCharacteristic("2A6E") : nullptr;
  if (!ch) { cl->disconnect(); return false; }
  if (ch->canNotify()) ch->subscribe(true, onNotifica);
  else if (ch->canRead()) {
    std::string v = ch->readValue();
    // ...
  }
  return true;
}
