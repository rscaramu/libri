// ESP32 — La guida completa alla famiglia · capitolo 24 (Wi-Fi)
// Listato 24.1 — Connessione a eventi. `loop()` non aspetta mai; se la rete cade, l'evento di disconnessione la riavvia.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <WiFi.h>

const char *SSID = "MiaRete";
const char *PASS = "segreto";

void onWiFi(WiFiEvent_t ev, WiFiEventInfo_t info) {
  switch (ev) {
    case ARDUINO_EVENT_WIFI_STA_GOT_IP:
      Serial.printf("IP %s\n", WiFi.localIP().toString().c_str());
      break;
    case ARDUINO_EVENT_WIFI_STA_DISCONNECTED:
      Serial.printf("disconnesso, motivo %d\n",
                    info.wifi_sta_disconnected.reason);
      WiFi.reconnect();
      break;
    default: break;
  }
}

void setup() {
  Serial.begin(115200);
  WiFi.onEvent(onWiFi);
  WiFi.mode(WIFI_STA);
  WiFi.setAutoReconnect(true);
  WiFi.begin(SSID, PASS);
}

void loop() {
  // fa il suo lavoro; la rete è gestita dagli eventi
}
