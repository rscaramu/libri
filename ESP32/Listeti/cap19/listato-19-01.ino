// ESP32 — La guida completa alla famiglia · capitolo 19 (Timer, RMT, PCNT)
// Listato 19.1 — Un timer che chiama una ISR ogni 100 millisecondi. La firma di `timerBegin` è cambiata nel core 3.x: prende la frequenza, non il numero del timer e il divisore.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

hw_timer_t *timer = NULL;
volatile uint32_t tick = 0;

void IRAM_ATTR onTimer(void) {
  tick++;
}

void setup() {
  timer = timerBegin(1000000);           // 1 MHz: 1 tick = 1 us
  timerAttachInterrupt(timer, &onTimer);
  timerAlarm(timer, 100000, true, 0);    // ogni 100 ms, ripetuto
}
