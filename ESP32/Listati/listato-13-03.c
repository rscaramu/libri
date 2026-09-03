// ESP32 — La guida completa alla famiglia · capitolo 13 (FreeRTOS e multicore)
// Listato 13.3 — Una sezione critica intorno a un contatore. Le due varianti, con e senza `_ISR`, servono rispettivamente dentro e fuori le routine di interrupt.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

static portMUX_TYPE mux = portMUX_INITIALIZER_UNLOCKED;
static volatile uint32_t conteggio = 0;

void IRAM_ATTR onPulse(void *arg) {
  portENTER_CRITICAL_ISR(&mux);
  conteggio++;
  portEXIT_CRITICAL_ISR(&mux);
}

uint32_t leggiEAzzera(void) {
  portENTER_CRITICAL(&mux);
  uint32_t v = conteggio;
  conteggio = 0;
  portEXIT_CRITICAL(&mux);
  return v;
}
