// ESP32 — La guida completa alla famiglia · capitolo 29 (ESP-NOW e reti proprietarie)
// Listato 29.2 — Il ricevente. Non deve registrare il mittente come peer per ricevere; deve farlo solo se vuole rispondergli.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

typedef struct { float temp; uint32_t seq; } Msg;

void onRicevuto(const esp_now_recv_info_t *info,
                const uint8_t *data, int len) {
  if (len != sizeof(Msg)) return;
  Msg m; memcpy(&m, data, sizeof m);
  Serial.printf("da %02X:%02X:%02X:%02X:%02X:%02X  "
                "#%lu  %.1f °C\n",
                info->src_addr[0], info->src_addr[1],
                info->src_addr[2], info->src_addr[3],
                info->src_addr[4], info->src_addr[5],
                m.seq, m.temp);
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  Serial.println(WiFi.macAddress());   // da copiare nel mittente
  esp_now_init();
  esp_now_register_recv_cb(onRicevuto);
}
