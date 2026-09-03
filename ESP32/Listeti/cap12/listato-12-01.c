// ESP32 — La guida completa alla famiglia · capitolo 12 (Memoria)
// Listato 12.1 — I tre attributi di posizionamento. Senza `DRAM_ATTR`, una costante finisce in flash e una ISR che la legge durante una scrittura in flash va in crash.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

// Routine di interrupt: deve stare in IRAM
void IRAM_ATTR onPulse(void *arg) { ... }

// Tabella consultata da una ISR: deve stare in DRAM,
// non in flash, perché la ISR può girare a cache spenta
DRAM_ATTR static const uint8_t lut[16] = { ... };

// Contatore che sopravvive al deep sleep
RTC_DATA_ATTR static int risvegli = 0;
