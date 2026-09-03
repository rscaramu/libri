// ESP32 — La guida completa alla famiglia · capitolo 18 (PWM: LEDC e MCPWM)
// Frammento — Un LED che sembri lineare
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

uint16_t gamma(uint8_t livello) {       // 0..255 → 0..1023
  float x = livello / 255.0f;
  return (uint16_t)(x * x * x * 1023.0f + 0.5f);
}
