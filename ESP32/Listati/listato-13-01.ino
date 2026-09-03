// ESP32 — La guida completa alla famiglia · capitolo 13 (FreeRTOS e multicore)
// Listato 13.1 — Creazione di un task assegnato al core 0. `xTaskCreate` senza `PinnedToCore` lascia scegliere allo scheduler.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

void taskSensore(void *param) {
  for (;;) {
    float t = leggiTemperatura();
    xQueueSend(codaMisure, &t, 0);
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

void setup() {
  xTaskCreatePinnedToCore(
    taskSensore,   // funzione
    "sensore",     // nome, per il debug
    4096,          // stack in byte
    NULL,          // parametro passato alla funzione
    2,             // priorità
    NULL,          // handle, se serve controllarlo dopo
    0              // core: 0, 1, o tskNO_AFFINITY
  );
}
