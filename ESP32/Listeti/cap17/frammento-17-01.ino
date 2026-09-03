// ESP32 — La guida completa alla famiglia · capitolo 17 (ADC, DAC, touch)
// Frammento — Attenuazioni e calibrazione
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

analogSetAttenuation(ADC_12db);
uint32_t mv = analogReadMilliVolts(34);   // già calibrato
