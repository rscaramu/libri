// ESP32 — La guida completa alla famiglia · capitolo 16 (GPIO)
// Listato 16.1 — Interrupt su fronte di discesa con debounce temporale. `millis()` è sicura da chiamare in una ISR sull'ESP32; `delay()` e `Serial` no.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#define PIN_PULSANTE 4

volatile uint32_t pressioni = 0;
volatile uint32_t ultimo = 0;

void IRAM_ATTR onPulsante(void) {
  uint32_t ora = millis();
  if (ora - ultimo > 50) {        // debounce: ignora < 50 ms
    pressioni++;
    ultimo = ora;
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(PIN_PULSANTE, INPUT_PULLUP);
  attachInterrupt(PIN_PULSANTE, onPulsante, FALLING);
}

void loop() {
  Serial.println(pressioni);
  delay(1000);
}
