// ESP32 — La guida completa alla famiglia · capitolo 26 (MQTT e domotica)
// Listato 26.3 — Un annuncio di discovery per un sensore di temperatura. Pubblicato retained, sopravvive ai riavvii di Home Assistant. Le chiavi abbreviate sono quelle documentate.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

void annuncia(void) {
  JsonDocument d;
  d["name"] = "Temperatura salotto";
  d["uniq_id"] = "salotto-1-temp";
  d["stat_t"] = "casa/salotto/temperatura";
  d["avty_t"] = "casa/salotto/status";
  d["unit_of_meas"] = "°C";
  d["dev_cla"] = "temperature";
  d["stat_cla"] = "measurement";
  JsonObject dev = d["dev"].to<JsonObject>();
  dev["ids"][0] = "salotto-1";
  dev["name"] = "Sensore salotto";
  dev["mf"] = "Io";
  dev["mdl"] = "ESP32-C6";
  String out;
  serializeJson(d, out);
  mqtt.publish("homeassistant/sensor/salotto-1/temp/config",
               out.c_str(), true);
}
