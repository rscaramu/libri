// ESP32 — La guida completa alla famiglia · capitolo 33 (OTA)
// Listato 33.1 — La conferma del nuovo firmware. `tuttoFunziona()` deve verificare ciò che conta davvero: connessione, comunicazione con il server, sensori. Una conferma incondizionata all'avvio rende il rollback inutile.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_ota_ops.h>

void setup() {
  // ... avvio, connessione Wi-Fi, connessione al broker ...
  if (tuttoFunziona()) {
    esp_ota_mark_app_valid_cancel_rollback();
  } else {
    esp_ota_mark_app_invalid_rollback_and_reboot();
  }
}
