// ESP32 — La guida completa alla famiglia · capitolo 24 (Wi-Fi)
// Frammento — Station, AP e modalità mista
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

WiFi.mode(WIFI_AP);
WiFi.softAP("ESP32-Setup", "12345678");   // password ≥ 8 caratteri
Serial.println(WiFi.softAPIP());
