// ESP32 — La guida completa alla famiglia · capitolo 24 (Wi-Fi)
// Listato 24.3 — WiFiManager: se le credenziali salvate funzionano, si connette; altrimenti apre il portale per tre minuti.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <WiFiManager.h>

void setup() {
  WiFiManager wm;
  wm.setConfigPortalTimeout(180);
  if (!wm.autoConnect("ESP32-Config")) ESP.restart();
  // da qui il Wi-Fi è connesso e le credenziali sono in NVS
}
