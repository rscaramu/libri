// ESP32 — La guida completa alla famiglia · capitolo 18 (PWM: LEDC e MCPWM)
// Listato 18.1 — Dissolvenza con LEDC nel core 3.x. Nel 2.x la stessa cosa richiedeva `ledcSetup` e `ledcAttachPin` con un numero di canale esplicito.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#define PIN_LED 4

void setup() {
  ledcAttach(PIN_LED, 5000, 8);      // 5 kHz, 8 bit
}

void loop() {
  for (int d = 0; d <= 255; d++) { ledcWrite(PIN_LED, d); delay(4); }
  for (int d = 255; d >= 0; d--) { ledcWrite(PIN_LED, d); delay(4); }
}
