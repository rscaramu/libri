// ESP32 — La guida completa alla famiglia · capitolo 13 (FreeRTOS e multicore)
// Frammento — Code, semafori, mutex, event group
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

void IRAM_ATTR onEdge(void *arg) {
  uint32_t ts = micros();
  BaseType_t woke = pdFALSE;
  xQueueSendFromISR(codaEventi, &ts, &woke);
  if (woke) portYIELD_FROM_ISR();
}
