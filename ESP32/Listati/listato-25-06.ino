// ESP32 — La guida completa alla famiglia · capitolo 25 (Rete e protocolli)
// Listato 25.6 — Un WebSocket che spinge la temperatura dieci volte al secondo a tutti i browser collegati e riceve comandi. Dal browser: `new WebSocket("ws://" + location.host + "/ws")`.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

AsyncWebSocket ws("/ws");

void onWs(AsyncWebSocket *s, AsyncWebSocketClient *c,
          AwsEventType t, void *arg, uint8_t *data, size_t len) {
  if (t == WS_EVT_DATA) {
    // comando dal browser
    String cmd((char *)data, len);
    if (cmd == "led:on") digitalWrite(2, HIGH);
  }
}

void setup() {
  ws.onEvent(onWs);
  server.addHandler(&ws);
  // ...
}

void loop() {
  static uint32_t ultimo = 0;
  if (millis() - ultimo > 100) {
    ultimo = millis();
    ws.textAll(String("{\"temp\":") + temperatura + "}");
    ws.cleanupClients();
  }
}
