# ESP32 — La guida completa alla famiglia · capitolo 8 (ESP-IDF)
# Frammento — Installazione
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

git clone -b v5.5 --recursive \
    https://github.com/espressif/esp-idf.git
cd esp-idf
./install.sh esp32,esp32s3,esp32c6
. ./export.sh
