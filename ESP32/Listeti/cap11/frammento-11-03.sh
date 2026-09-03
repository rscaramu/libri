# ESP32 — La guida completa alla famiglia · capitolo 11 (Flash, partizioni e strumenti a basso livello)
# Frammento — esptool
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

esptool.py --port /dev/ttyUSB0 read_flash 0 0x400000 backup.bin
