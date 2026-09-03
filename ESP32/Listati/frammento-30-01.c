// ESP32 — La guida completa alla famiglia · capitolo 30 (Sleep e consumi)
// Frammento — I modi di sonno
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_pm.h>

esp_pm_config_t pm = {
    .max_freq_mhz = 160,
    .min_freq_mhz = 40,
    .light_sleep_enable = true,
};
esp_pm_configure(&pm);
