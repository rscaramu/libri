// ESP32 — La guida completa alla famiglia · capitolo 25 (Rete e protocolli)
// Listato 25.1 — Un GET con timeout e gestione dell'errore. `http.end()` va chiamata sempre, anche in caso di errore, o la connessione resta aperta.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <HTTPClient.h>

String scarica(const char *url) {
  if (WiFi.status() != WL_CONNECTED) return "";
  HTTPClient http;
  http.setTimeout(5000);
  http.begin(url);
  http.addHeader("Accept", "application/json");
  int code = http.GET();
  String body = (code == HTTP_CODE_OK) ? http.getString() : "";
  if (code != HTTP_CODE_OK)
    Serial.printf("HTTP %d: %s\n", code,
                  http.errorToString(code).c_str());
  http.end();
  return body;
}
