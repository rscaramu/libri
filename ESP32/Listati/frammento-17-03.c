// ESP32 — La guida completa alla famiglia · capitolo 17 (ADC, DAC, touch)
// Frammento — Misurare la tensione della batteria
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#define PIN_BATT 34
#define FATTORE 2.0f   // partitore 1:2

float tensioneBatteria(void) {
  uint32_t mv = leggiMedia(PIN_BATT, 32);
  return mv * FATTORE / 1000.0f;
}
