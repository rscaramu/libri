// ESP32 — La guida completa alla famiglia · capitolo 17 (ADC, DAC, touch)
// Frammento — Touch capacitivo
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

void setup() {
  Serial.begin(115200);
}

void loop() {
  Serial.println(touchRead(T0));   // T0 = GPIO 4 sull'ESP32
  delay(100);
}
