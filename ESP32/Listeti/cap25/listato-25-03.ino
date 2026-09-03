// ESP32 — La guida completa alla famiglia · capitolo 25 (Rete e protocolli)
// Listato 25.3 — HTTPS con il bundle di certificati. In ESP-IDF è `esp_crt_bundle_attach` nella configurazione del client, e l'opzione *Certificate Bundle* in `menuconfig`.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <WiFiClientSecure.h>
#include <HTTPClient.h>

WiFiClientSecure client;
client.setCACertBundle(x509_crt_imported_bundle_bin_start);
// oppure, nel core Arduino recente:
// client.setCACertBundle(NULL);  // usa il bundle incorporato

HTTPClient http;
http.begin(client, "https://api.example.com/dati");
int code = http.GET();
