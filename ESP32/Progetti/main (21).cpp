// Progetto 37.2 — Il `loop()` del nodo. Lo stato del relè è salvato in NVS e ripristinato all'avvio, così un black-out non spegne la lampada.
// Nucleo del programma come nel libro. Le funzioni di supporto sono in helpers.h.

#include "helpers.h"

#include <WiFi.h>
#include <PubSubClient.h>
#include <Preferences.h>
#include <WiFiManager.h>
#include <ArduinoOTA.h>

WiFiClient net;
PubSubClient mqtt(net);
Preferences prefs;
void impostaRele(bool on);
void IRAM_ATTR onPulsante(void);

void setup() {
  Serial.begin(115200);
  pinMode(PIN_RELE, OUTPUT);
  pinMode(PIN_PULSANTE, INPUT_PULLUP);
  prefs.begin("nodo", false);
  impostaRele(prefs.getBool("rele", false));      // ripristino
  WiFiManager wm;                                // listato 24.3
  wm.setConfigPortalTimeout(180);
  if (!wm.autoConnect("Nodo-Config")) ESP.restart();
  mqtt.setServer("192.168.1.10", 1883);
  mqtt.setBufferSize(1024);
  mqtt.setCallback(onMessaggio);
  attachInterrupt(PIN_PULSANTE, onPulsante, FALLING);
  ArduinoOTA.setHostname("nodo-cucina");          // listato 33.2
  ArduinoOTA.setPassword("cambiami");
  ArduinoOTA.begin();
  // annuncio di discovery per Home Assistant: listato 26.3
}

volatile bool premuto = false;
void IRAM_ATTR onPulsante(void) { premuto = true; }

void impostaRele(bool on) {
  digitalWrite(PIN_RELE, on);
  mqtt.publish("casa/cucina/rele/state", on ? "ON" : "OFF", true);
  prefs.putBool("rele", on);        // ripristino dopo un black-out
}

void onMessaggio(char *topic, byte *p, unsigned int n) {
  if (strcmp(topic, "casa/cucina/rele/set") == 0)
    impostaRele(n == 2 && p[0] == 'O' && p[1] == 'N');
}

void loop() {
  gestisciRete();
  if (connettiMqtt()) mqtt.loop();
  ArduinoOTA.handle();

  if (premuto) {
    premuto = false;
    static uint32_t ultimo = 0;
    if (millis() - ultimo > 300) {
      ultimo = millis();
      impostaRele(!digitalRead(PIN_RELE));
    }
  }

  static uint32_t tSens = 0;
  if (millis() - tSens > 60000) {
    tSens = millis();
    float t = leggiDS18B20();
    if (!isnan(t)) {
      char b[16]; snprintf(b, sizeof b, "%.1f", t);
      mqtt.publish("casa/cucina/temperatura", b, true);
    }
  }
}
