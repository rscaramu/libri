# ESP32 — La guida completa alla famiglia · capitolo 36 (Produzione e certificazioni)
# Frammento — Provisioning di massa
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

python nvs_partition_gen.py generate valori.csv nvs-000123.bin 0x6000
esptool.py write_flash 0x9000 nvs-000123.bin
