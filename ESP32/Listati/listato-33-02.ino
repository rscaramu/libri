// ESP32 — La guida completa alla famiglia · capitolo 33 (OTA)
// Listato 33.2 — ArduinoOTA. Dopo il primo caricamento via USB, il dispositivo compare in `Tools → Port` come porta di rete. PlatformIO lo usa con `upload_protocol = espota` e `upload_port = salotto-1.local`.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <ArduinoOTA.h>

void setup() {
  // ... Wi-Fi ...
  ArduinoOTA.setHostname("salotto-1");
  ArduinoOTA.setPassword("cambiami");
  ArduinoOTA.onStart([]() { Serial.println("OTA avvio"); });
  ArduinoOTA.onProgress([](unsigned int p, unsigned int t) {
    Serial.printf("%u%%\r", p * 100 / t);
  });
  ArduinoOTA.onError([](ota_error_t e) {
    Serial.printf("OTA errore %u\n", e);
  });
  ArduinoOTA.begin();
}

void loop() {
  ArduinoOTA.handle();
}
