// ESP32 — La guida completa alla famiglia · capitolo 28 (Thread, Zigbee, Matter)
// Listato 28.1 — Una luce Zigbee su un C6 con la libreria Arduino. Il dispositivo appare in Zigbee2MQTT o in un hub commerciale come una luce generica.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <Zigbee.h>

#define LED_PIN 8
ZigbeeLight luce(10);     // endpoint 10

void onCambio(bool on) {
  digitalWrite(LED_PIN, on);
}

void setup() {
  pinMode(LED_PIN, OUTPUT);
  luce.setManufacturerAndModel("Io", "LampadaC6");
  luce.onLightChange(onCambio);
  Zigbee.addEndpoint(&luce);
  if (!Zigbee.begin(ZIGBEE_END_DEVICE)) ESP.restart();
  while (!Zigbee.connected()) delay(100);
}

void loop() {
  if (digitalRead(9) == LOW) {        // BOOT tenuto 3 s: reset
    delay(3000);
    if (digitalRead(9) == LOW) Zigbee.factoryReset();
  }
}
