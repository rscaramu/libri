// Funzioni di supporto del progetto 37.1, composte dai listati 30.3 e 26.1.
#include "helpers.h"
#include <WiFi.h>
#include <PubSubClient.h>

// --- da personalizzare ---
static const char *SSID   = "MiaRete";
static const char *PASS   = "segreto";
static const char *BROKER = "192.168.1.10";
static const char *ID     = "esterno-1";

extern PubSubClient mqtt;
extern RTC_DATA_ATTR uint8_t canale;
extern RTC_DATA_ATTR uint8_t bssid[6];

// Listato 30.3 — connessione rapida con canale e BSSID in cache, IP statico
bool connettiVeloce(void) {
  WiFi.mode(WIFI_STA);
  WiFi.config(IPAddress(192, 168, 1, 50), IPAddress(192, 168, 1, 1),
              IPAddress(255, 255, 255, 0), IPAddress(192, 168, 1, 1));
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

// Listato 26.1, ridotto: una sola connessione, senza ciclo di riconnessione
bool mqttConnetti(void) {
  mqtt.setServer(BROKER, 1883);
  mqtt.setBufferSize(512);
  return mqtt.connect(ID, "utente", "password");
}
