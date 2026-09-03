// ESP32 — La guida completa alla famiglia · capitolo 29 (ESP-NOW e reti proprietarie)
// Listato 29.1 — Un mittente ESP-NOW. Il ricevente registra `esp_now_register_recv_cb` e riceve la struttura così com'è: le due parti devono avere la stessa definizione.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <WiFi.h>
#include <esp_now.h>

uint8_t destinatario[] = { 0x24, 0x6F, 0x28, 0xAA, 0xBB, 0xCC };

typedef struct { float temp; uint32_t seq; } Msg;

void onInviato(const uint8_t *mac, esp_now_send_status_t st) {
  Serial.println(st == ESP_NOW_SEND_SUCCESS ? "ok" : "fallito");
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  esp_now_init();
  esp_now_register_send_cb(onInviato);
  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, destinatario, 6);
  peer.channel = 1;
  peer.encrypt = false;
  esp_now_add_peer(&peer);
}

void loop() {
  static Msg m = { 0, 0 };
  m.temp = leggiTemperatura(); m.seq++;
  esp_now_send(destinatario, (uint8_t *)&m, sizeof m);
  delay(1000);
}
