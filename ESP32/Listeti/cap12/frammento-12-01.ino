// ESP32 — La guida completa alla famiglia · capitolo 12 (Memoria)
// Frammento — Frammentazione dell'heap
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

Serial.printf("Heap libero: %u  blocco max: %u\n",
              ESP.getFreeHeap(), ESP.getMaxAllocHeap());
