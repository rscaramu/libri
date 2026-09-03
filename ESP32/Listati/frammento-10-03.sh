# ESP32 — La guida completa alla famiglia · capitolo 10 (MicroPython e le alternative)
# Frammento — MicroPython
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

$ mpremote
Connected to MicroPython at /dev/ttyUSB0
>>> from machine import Pin
>>> led = Pin(2, Pin.OUT)
>>> led.value(1)
>>> led.value(0)
