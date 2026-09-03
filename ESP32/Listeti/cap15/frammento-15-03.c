// ESP32 — La guida completa alla famiglia · capitolo 15 (Clock, reset, watchdog e log)
// Frammento — Il sistema di log
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "esp_log.h"
static const char *TAG = "sensore";

ESP_LOGE(TAG, "lettura fallita: %d", err);   // errore
ESP_LOGW(TAG, "valore fuori scala");          // avviso
ESP_LOGI(TAG, "temperatura %.1f", t);         // informazione
ESP_LOGD(TAG, "raw = %u", raw);               // debug
ESP_LOGV(TAG, "entro in lettura");            // verboso
