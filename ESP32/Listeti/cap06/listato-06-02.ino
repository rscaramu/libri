// ESP32 — La guida completa alla famiglia · capitolo 6 (Il primo progetto in mezz'ora)
// Listato 6.2 — Il lampeggio con messaggi sulla seriale. `Serial.printf()` esiste sull'ESP32 e non su molti altri Arduino: è comodissimo e lo useremo sempre.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#define LED_PIN 2

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("Avvio");
  Serial.printf("Chip: %s, %d core, %d MHz\n",
                ESP.getChipModel(), ESP.getChipCores(),
                ESP.getCpuFreqMHz());
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_PIN, HIGH);
  Serial.println("acceso");
  delay(500);
  digitalWrite(LED_PIN, LOW);
  Serial.println("spento");
  delay(500);
}
