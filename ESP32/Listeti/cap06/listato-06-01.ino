// ESP32 — La guida completa alla famiglia · capitolo 6 (Il primo progetto in mezz'ora)
// Listato 6.1 — Il lampeggio. Sull'ESP32 classico il LED di bordo è sul GPIO2; su molte schede S3 e C3 è su un altro pin, riportato sulla serigrafia o nella documentazione.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#define LED_PIN 2

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_PIN, HIGH);
  delay(500);
  digitalWrite(LED_PIN, LOW);
  delay(500);
}
