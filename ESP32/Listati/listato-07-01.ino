// ESP32 — La guida completa alla famiglia · capitolo 7 (Arduino-ESP32 3.x)
// Listato 7.1 — Una funzione ESP-IDF chiamata da uno sketch Arduino. L'intestazione `esp_system.h` è nella cartella del core.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_system.h>

void setup() {
  Serial.begin(115200);
  delay(1000);
  esp_reset_reason_t r = esp_reset_reason();
  Serial.printf("Causa del reset: %d\n", r);
  // ESP_RST_POWERON = 1, ESP_RST_SW = 3,
  // ESP_RST_PANIC = 4, ESP_RST_DEEPSLEEP = 8
}

void loop() {}
