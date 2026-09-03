// ESP32 — La guida completa alla famiglia · capitolo 30 (Sleep e consumi)
// Listato 30.1 — Light sleep esplicito: cinque secondi o un pulsante, e la RAM è intatta al risveglio. Il Wi-Fi, se connesso, va spento prima o si perde la connessione.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_sleep.h>

void loop() {
  leggiSensore();
  gpio_wakeup_enable(GPIO_NUM_4, GPIO_INTR_LOW_LEVEL);
  esp_sleep_enable_gpio_wakeup();
  esp_sleep_enable_timer_wakeup(5 * 1000000ULL);
  esp_light_sleep_start();                 // torna qui al risveglio
  if (esp_sleep_get_wakeup_cause() == ESP_SLEEP_WAKEUP_GPIO)
    gestisciPulsante();
}
