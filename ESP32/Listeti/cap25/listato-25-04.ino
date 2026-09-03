// ESP32 — La guida completa alla famiglia · capitolo 25 (Rete e protocolli)
// Listato 25.4 — Un server asincrono con file statici da LittleFS e due API JSON. Le pagine HTML, CSS e JavaScript stanno nel filesystem, non nel codice.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <ESPAsyncWebServer.h>
#include <ArduinoJson.h>
#include <LittleFS.h>

AsyncWebServer server(80);
float temperatura = 21.5f;

void setup() {
  LittleFS.begin(true);
  // ... Wi-Fi ...

  server.serveStatic("/", LittleFS, "/")
        .setDefaultFile("index.html")
        .setCacheControl("max-age=600");

  server.on("/api/stato", HTTP_GET, [](AsyncWebServerRequest *r) {
    JsonDocument d;
    d["temp"] = temperatura;
    d["uptime"] = millis() / 1000;
    d["rssi"] = WiFi.RSSI();
    String out;
    serializeJson(d, out);
    r->send(200, "application/json", out);
  });

  server.on("/api/led", HTTP_POST, [](AsyncWebServerRequest *r) {
    if (!r->hasParam("on", true))
      return r->send(400, "text/plain", "manca 'on'");
    bool on = r->getParam("on", true)->value() == "1";
    digitalWrite(2, on);
    r->send(200, "text/plain", "ok");
  });

  server.onNotFound([](AsyncWebServerRequest *r) {
    r->send(404, "text/plain", "non trovato");
  });
  server.begin();
}

void loop() {}
