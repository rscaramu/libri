// ESP32 — La guida completa alla famiglia · capitolo 28 (Thread, Zigbee, Matter)
// Listato 28.2 — Una luce Matter su Wi-Fi con la libreria Arduino. Il codice di abbinamento si stampa sulla seriale; l'app Home lo accetta.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <Matter.h>
#include <WiFi.h>

MatterOnOffLight luce;

void setup() {
  Serial.begin(115200);
  WiFi.begin("MiaRete", "segreto");
  while (WiFi.status() != WL_CONNECTED) delay(200);

  luce.begin(false);
  luce.onChange([](bool on) {
    digitalWrite(8, on);
    return true;
  });
  Matter.begin();

  if (!Matter.isDeviceCommissioned()) {
    Serial.println("Codice: " + Matter.getManualPairingCode());
    Serial.println("QR: " + Matter.getOnboardingQRCodeUrl());
  }
}

void loop() { delay(100); }
