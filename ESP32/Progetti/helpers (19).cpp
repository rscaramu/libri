// Funzioni di supporto del progetto 37.2, composte dai listati 24.2 e 26.1.
#include "helpers.h"
#include <WiFi.h>
#include <PubSubClient.h>
#include <Preferences.h>
#include <OneWire.h>
#include <DallasTemperature.h>

extern PubSubClient mqtt;
extern Preferences prefs;
extern void onMessaggio(char *topic, byte *p, unsigned int n);

static const char *ID = "cucina-1";
static OneWire ow(4);
static DallasTemperature ds(&ow);

// Listato 24.2 — riconnessione con backoff esponenziale e riavvio dopo un'ora
void gestisciRete(void) {
  static uint32_t backoffMs = 1000, ultimoTentativo = 0, disconnessoDa = 0;
  if (WiFi.status() == WL_CONNECTED) { backoffMs = 1000; disconnessoDa = 0; return; }
  uint32_t ora = millis();
  if (disconnessoDa == 0) disconnessoDa = ora;
  if (ora - disconnessoDa > 3600000UL) ESP.restart();
  if (ora - ultimoTentativo > backoffMs) {
    ultimoTentativo = ora;
    WiFi.reconnect();
    backoffMs = min(backoffMs * 2, 60000U);
  }
}

// Listato 26.1 — connessione MQTT con last will e stato retained
bool connettiMqtt(void) {
  if (mqtt.connected()) return true;
  static uint32_t ultimo = 0;
  if (millis() - ultimo < 5000) return false;
  ultimo = millis();
  bool ok = mqtt.connect(ID, "utente", "password",
                         "casa/cucina/status", 1, true, "offline");
  if (ok) {
    mqtt.publish("casa/cucina/status", "online", true);
    mqtt.subscribe("casa/cucina/rele/set", 1);
  }
  return ok;
}

float leggiDS18B20(void) {
  static bool init = false;
  if (!init) { ds.begin(); init = true; }
  ds.requestTemperatures();
  float t = ds.getTempCByIndex(0);
  return (t == DEVICE_DISCONNECTED_C) ? NAN : t;
}
