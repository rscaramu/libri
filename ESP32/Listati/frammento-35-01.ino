// ESP32 — La guida completa alla famiglia · capitolo 35 (Debug e collaudo)
// Frammento — Profiling
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

char buf[1024];
vTaskGetRunTimeStats(buf);   // CONFIG_FREERTOS_GENERATE_RUN_TIME_STATS
Serial.println(buf);
