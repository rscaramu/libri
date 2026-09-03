# ESP32 — La guida completa alla famiglia · capitolo 10 (MicroPython e le alternative)
# Frammento — MicroPython
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

esptool.py --chip esp32 --port /dev/ttyUSB0 erase_flash
esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 460800 \
    write_flash -z 0x1000 ESP32_GENERIC-20260601-v1.26.bin
