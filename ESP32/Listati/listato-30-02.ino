// ESP32 — La guida completa alla famiglia · capitolo 30 (Sleep e consumi)
// Listato 30.2 — Un sensore che dorme dieci minuti, si sveglia con il timer o con un pulsante, e trasmette solo se la temperatura è cambiata o una volta l'ora. Le due variabili in RTC RAM sono l'unica memoria fra un ciclo e l'altro.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_sleep.h>

#define uS_TO_S 1000000ULL
RTC_DATA_ATTR int risvegli = 0;
RTC_DATA_ATTR float ultimaTemp = 0;

void setup() {
  Serial.begin(115200);
  risvegli++;

  esp_sleep_wakeup_cause_t causa = esp_sleep_get_wakeup_cause();
  switch (causa) {
    case ESP_SLEEP_WAKEUP_TIMER: Serial.println("timer"); break;
    case ESP_SLEEP_WAKEUP_EXT0:  Serial.println("pin");   break;
    default: Serial.println("accensione o reset");        break;
  }

  float t = leggiTemperatura();
  if (fabsf(t - ultimaTemp) > 0.2f || risvegli % 6 == 0) {
    ultimaTemp = t;
    connettiEInvia(t);              // solo se serve davvero
  }

  esp_sleep_enable_timer_wakeup(600 * uS_TO_S);      // 10 min
  esp_sleep_enable_ext0_wakeup(GPIO_NUM_33, 0);      // pulsante
  Serial.flush();
  esp_deep_sleep_start();
}

void loop() {}
