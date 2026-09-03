// ESP32 — La guida completa alla famiglia · capitolo 24 (Wi-Fi)
// Listato 24.5 — Uno sniffer che stampa l'indirizzo sorgente e la potenza di ogni frame sul canale 6. La callback gira nel contesto dello stack: deve essere veloce, e in un progetto vero mette i dati in una coda.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_wifi.h>

void IRAM_ATTR onFrame(void *buf, wifi_promiscuous_pkt_type_t t) {
  wifi_promiscuous_pkt_t *p = (wifi_promiscuous_pkt_t *)buf;
  const uint8_t *mac = p->payload + 10;      // indirizzo sorgente
  Serial.printf("%02X:%02X:%02X:%02X:%02X:%02X  %d dBm\n",
                mac[0], mac[1], mac[2], mac[3], mac[4], mac[5],
                p->rx_ctrl.rssi);
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  esp_wifi_set_promiscuous(true);
  esp_wifi_set_promiscuous_rx_cb(onFrame);
  esp_wifi_set_channel(6, WIFI_SECOND_CHAN_NONE);
}
