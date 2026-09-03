// ESP32 — La guida completa alla famiglia · capitolo 15 (Clock, reset, watchdog e log)
// Frammento — I tre watchdog
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_task_wdt.h>

esp_task_wdt_add(NULL);          // registra il task corrente
for (...) {
  elaboraBlocco();
  esp_task_wdt_reset();          // "sono vivo"
}
esp_task_wdt_delete(NULL);
