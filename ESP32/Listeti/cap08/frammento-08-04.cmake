# ESP32 — La guida completa alla famiglia · capitolo 8 (ESP-IDF)
# Frammento — Il sistema di build e i componenti
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

idf_component_register(SRCS "main.c" "wifi.c"
                       INCLUDE_DIRS "."
                       REQUIRES esp_wifi nvs_flash)
