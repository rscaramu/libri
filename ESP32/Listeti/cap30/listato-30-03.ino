// ESP32 — La guida completa alla famiglia · capitolo 30 (Sleep e consumi)
// Listato 30.3 — Connessione rapida con canale e BSSID conservati in RTC RAM e IP statico. Se fallisce, il ciclo successivo fa una connessione normale e aggiorna la cache.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

RTC_DATA_ATTR uint8_t canale = 0;
RTC_DATA_ATTR uint8_t bssid[6];

bool connettiVeloce(void) {
  WiFi.mode(WIFI_STA);
  WiFi.config(IPAddress(192,168,1,50), IPAddress(192,168,1,1),
              IPAddress(255,255,255,0), IPAddress(192,168,1,1));
  if (canale) WiFi.begin(SSID, PASS, canale, bssid, true);
  else        WiFi.begin(SSID, PASS);
  uint32_t t0 = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - t0 < 5000)
    delay(10);
  if (WiFi.status() != WL_CONNECTED) { canale = 0; return false; }
  canale = WiFi.channel();
  memcpy(bssid, WiFi.BSSID(), 6);
  return true;
}
