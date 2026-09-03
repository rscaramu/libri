// ESP32 — La guida completa alla famiglia · capitolo 26 (MQTT e domotica)
// Listato 26.1 — Un client con last will, riconnessione temporizzata, stato retained e conferma dei comandi. `setBufferSize(1024)` è necessario per i messaggi di discovery del paragrafo successivo.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <WiFi.h>
#include <PubSubClient.h>

WiFiClient net;
PubSubClient mqtt(net);
const char *BROKER = "192.168.1.10";
const char *ID = "salotto-1";

void onMessaggio(char *topic, byte *payload, unsigned int len) {
  String msg((char *)payload, len);
  if (String(topic) == "casa/salotto/led/set")
    digitalWrite(2, msg == "ON");
    mqtt.publish("casa/salotto/led/state", msg.c_str(), true);
}

bool connetti(void) {
  if (mqtt.connected()) return true;
  static uint32_t ultimo = 0;
  if (millis() - ultimo < 5000) return false;
  ultimo = millis();
  bool ok = mqtt.connect(ID, "utente", "password",
                         "casa/salotto/status", 1, true, "offline");
  if (ok) {
    mqtt.publish("casa/salotto/status", "online", true);
    mqtt.subscribe("casa/salotto/led/set", 1);
  }
  return ok;
}

void setup() {
  // ... Wi-Fi ...
  mqtt.setServer(BROKER, 1883);
  mqtt.setBufferSize(1024);
  mqtt.setKeepAlive(30);
  mqtt.setCallback(onMessaggio);
}

void loop() {
  if (connetti()) mqtt.loop();
  static uint32_t t = 0;
  if (millis() - t > 60000) {
    t = millis();
    char buf[16];
    snprintf(buf, sizeof buf, "%.1f", leggiTemperatura());
    mqtt.publish("casa/salotto/temperatura", buf, true);
  }
}
