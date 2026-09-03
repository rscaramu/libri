// ESP32 — La guida completa alla famiglia · capitolo 24 (Wi-Fi)
// Listato 24.2 — Riconnessione con backoff esponenziale e riavvio dopo un'ora. Da chiamare in `loop()` o da un task dedicato.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

static uint32_t backoffMs = 1000;
static uint32_t ultimoTentativo = 0;
static uint32_t disconnessoDa = 0;

void gestisciRete(void) {
  if (WiFi.status() == WL_CONNECTED) {
    backoffMs = 1000; disconnessoDa = 0;
    return;
  }
  uint32_t ora = millis();
  if (disconnessoDa == 0) disconnessoDa = ora;
  if (ora - disconnessoDa > 3600000UL) ESP.restart();
  if (ora - ultimoTentativo > backoffMs) {
    ultimoTentativo = ora;
    WiFi.reconnect();
    backoffMs = min(backoffMs * 2, 60000U);
  }
}
