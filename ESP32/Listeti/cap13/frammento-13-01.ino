// ESP32 — La guida completa alla famiglia · capitolo 13 (FreeRTOS e multicore)
// Frammento — Cosa gira davvero quando scrivi loop()
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

char buf[1024];
vTaskList(buf);
Serial.println(buf);
