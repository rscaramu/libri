// ESP32 — La guida completa alla famiglia · capitolo 37 (Sette progetti, uno per famiglia)
// Listato 37.2 — Il `loop()` del nodo. Lo stato del relè è salvato in NVS e ripristinato all'avvio, così un black-out non spegne la lampada.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

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
