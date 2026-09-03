// ESP32 — La guida completa alla famiglia · capitolo 25 (Rete e protocolli)
// Listato 25.7 — Ora di rete con il fuso italiano e l'ora legale automatica. La stringa del fuso è nel formato POSIX; quella dell'Italia è questa.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

configTzTime("CET-1CEST,M3.5.0,M10.5.0/3",
             "pool.ntp.org", "time.google.com");

struct tm t;
if (getLocalTime(&t, 10000)) {          // aspetta fino a 10 s
  Serial.println(&t, "%d/%m/%Y %H:%M:%S");
}
