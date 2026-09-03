# ESP32 — La guida completa alla famiglia · capitolo 11 (Flash, partizioni e strumenti a basso livello)
# Frammento — esptool
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

esptool.py --chip esp32s3 merge_bin -o completo.bin \
    --flash_mode dio --flash_size 8MB \
    0x0 bootloader.bin 0x8000 partitions.bin \
    0x10000 firmware.bin
