// ESP32 — La guida completa alla famiglia · capitolo 7 (Arduino-ESP32 3.x)
// Frammento — Le rotture di compatibilità fra 2.x e 3.x
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

ledcAttach(4, 5000, 8);
ledcWrite(4, 128);
