// ESP32 — La guida completa alla famiglia · capitolo 17 (ADC, DAC, touch)
// Frammento — Ottenere misure decenti
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

uint32_t leggiMedia(int pin, int n) {
  uint64_t somma = 0;
  for (int i = 0; i < n; i++) somma += analogReadMilliVolts(pin);
  return somma / n;
}
