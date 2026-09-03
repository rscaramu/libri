// ESP32 — La guida completa alla famiglia · capitolo 19 (Timer, RMT, PCNT)
// Listato 19.2 — Un timer periodico con `esp_timer`. Funziona identico in Arduino e in ESP-IDF, e `esp_timer_get_time()` è il modo più preciso di misurare il tempo sull'ESP32.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_timer.h>

static void ogniSecondo(void *arg) {
  Serial.printf("t = %lld us\n", esp_timer_get_time());
}

void setup() {
  Serial.begin(115200);
  const esp_timer_create_args_t a = {
    .callback = ogniSecondo, .name = "tick"
  };
  esp_timer_handle_t h;
  esp_timer_create(&a, &h);
  esp_timer_start_periodic(h, 1000000);   // 1 s
}
