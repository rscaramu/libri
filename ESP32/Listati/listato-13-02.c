// ESP32 — La guida completa alla famiglia · capitolo 13 (FreeRTOS e multicore)
// Listato 13.2 — Una notifica usata come semaforo binario. Il primo parametro di `ulTaskNotifyTake` azzera il contatore alla ricezione.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

TaskHandle_t hLavoro;

// nel task che aspetta
void taskLavoro(void *p) {
  for (;;) {
    ulTaskNotifyTake(pdTRUE, portMAX_DELAY);
    faiIlLavoro();
  }
}

// da un altro task
xTaskNotifyGive(hLavoro);

// da una ISR
void IRAM_ATTR onPin(void *arg) {
  BaseType_t woke = pdFALSE;
  vTaskNotifyGiveFromISR(hLavoro, &woke);
  if (woke) portYIELD_FROM_ISR();
}
