// listato-21-02.ino — I due sonni dell'ESP32-S3. Il deep sleep con risveglio dal pin o dal timer, e una variabile che sopravvive; il light sleep che riparte dalla riga dopo.

#include "esp_sleep.h"
RTC_DATA_ATTR int risvegli = 0;      // sopravvive al deep sleep

void dormi(int pinSveglia, uint32_t timeoutMs) {
  esp_sleep_enable_ext0_wakeup((gpio_num_t)pinSveglia, 1);
  esp_sleep_enable_timer_wakeup((uint64_t)timeoutMs * 1000);
  risvegli++;
  esp_deep_sleep_start();            // riparte da setup()
}

void riposa(uint32_t ms) {           // light sleep: riparte da qui
  esp_sleep_enable_timer_wakeup((uint64_t)ms * 1000);
  esp_light_sleep_start();
}
