// ESP32 — La guida completa alla famiglia · capitolo 13 (FreeRTOS e multicore)
// Frammento — Code, semafori, mutex, event group
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

QueueHandle_t coda = xQueueCreate(10, sizeof(float));

// produttore
float t = 21.5f;
xQueueSend(coda, &t, pdMS_TO_TICKS(10));

// consumatore
float ricevuto;
if (xQueueReceive(coda, &ricevuto, portMAX_DELAY) == pdTRUE) {
  // usa ricevuto
}
