// ESP32 — La guida completa alla famiglia · capitolo 33 (OTA)
// Listato 33.3 — Controllo della versione e aggiornamento da HTTPS. Il file `latest.txt` contiene solo il numero di versione; il dispositivo scarica il binario solo se diverso dal proprio.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <HTTPUpdate.h>
#include <WiFiClientSecure.h>

#define VERSIONE "1.4.2"

void controllaAggiornamento(void) {
  WiFiClientSecure client;
  client.setCACertBundle(NULL);
  HTTPClient http;
  http.begin(client, "https://fw.example.com/salotto/latest.txt");
  if (http.GET() != 200) { http.end(); return; }
  String nuova = http.getString(); nuova.trim();
  http.end();
  if (nuova == VERSIONE) return;

  httpUpdate.rebootOnUpdate(true);
  t_httpUpdate_return r = httpUpdate.update(client,
      "https://fw.example.com/salotto/" + nuova + ".bin");
  if (r == HTTP_UPDATE_FAILED)
    Serial.printf("OTA fallito: %s\n",
                  httpUpdate.getLastErrorString().c_str());
}
