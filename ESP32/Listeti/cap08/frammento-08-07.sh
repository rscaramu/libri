# ESP32 — La guida completa alla famiglia · capitolo 8 (ESP-IDF)
# Frammento — idf.py
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

idf.py set-target esp32s3    # scegli il chip, una volta
idf.py menuconfig            # configura
idf.py build                 # compila
idf.py -p /dev/ttyUSB0 flash # programma
idf.py -p /dev/ttyUSB0 monitor
idf.py flash monitor         # i due insieme
idf.py size                  # occupazione di flash e RAM
idf.py fullclean             # ricomincia da zero
