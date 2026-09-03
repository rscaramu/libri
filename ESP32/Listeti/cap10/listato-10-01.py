# ESP32 — La guida completa alla famiglia · capitolo 10 (MicroPython e le alternative)
# Listato 10.1 — Il lampeggio in MicroPython. Si copia sulla scheda con `mpremote cp main.py :` e parte da solo al reset.
# Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
# e non definite qui sono indicate nella didascalia o nel capitolo.

from machine import Pin
import time

led = Pin(2, Pin.OUT)
while True:
    led.value(1)
    time.sleep_ms(500)
    led.value(0)
    time.sleep_ms(500)
