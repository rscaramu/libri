// ESP32 — La guida completa alla famiglia · capitolo 15 (Clock, reset, watchdog e log)
// Frammento — Il sistema di log
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

esp_log_level_set("wifi", ESP_LOG_WARN);   // zittisce il Wi-Fi
esp_log_level_set("*", ESP_LOG_INFO);      // tutto il resto
