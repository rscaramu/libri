// ESP32 — La guida completa alla famiglia · capitolo 24 (Wi-Fi)
// Listato 24.4 — Una scansione delle reti visibili. La versione asincrona, `scanNetworks(true)`, non blocca e si interroga con `scanComplete()`.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

int n = WiFi.scanNetworks();
for (int i = 0; i < n; i++) {
  bool aperta = WiFi.encryptionType(i) == WIFI_AUTH_OPEN;
  Serial.printf("%-24s ch %2d  %4d dBm  %s\n",
                WiFi.SSID(i).c_str(), WiFi.channel(i),
                WiFi.RSSI(i), aperta ? "aperta" : "");
}
WiFi.scanDelete();
