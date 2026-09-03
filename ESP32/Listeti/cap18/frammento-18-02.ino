// ESP32 — La guida completa alla famiglia · capitolo 18 (PWM: LEDC e MCPWM)
// Frammento — Servo ed ESC
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#define PIN_SERVO 18

void setup() {
  ledcAttach(PIN_SERVO, 50, 16);
}

void servoUs(uint32_t us) {            // 1000..2000
  uint32_t duty = (uint64_t)us * 65535 / 20000;
  ledcWrite(PIN_SERVO, duty);
}
