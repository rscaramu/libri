// ESP32 — La guida completa alla famiglia · capitolo 13 (FreeRTOS e multicore)
// Frammento — Code, semafori, mutex, event group
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

SemaphoreHandle_t mutexI2C = xSemaphoreCreateMutex();

if (xSemaphoreTake(mutexI2C, pdMS_TO_TICKS(100)) == pdTRUE) {
  leggiSensore();
  xSemaphoreGive(mutexI2C);
} else {
  // il bus è occupato da troppo tempo: segnala l'errore
}
