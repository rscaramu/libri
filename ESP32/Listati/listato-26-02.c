// ESP32 — La guida completa alla famiglia · capitolo 26 (MQTT e domotica)
// Listato 26.2 — Il client di ESP-IDF con TLS, last will e riconnessione automatica, che il driver gestisce da solo. In Arduino si può usare lo stesso client includendo `mqtt_client.h`.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "mqtt_client.h"

static void on_mqtt(void *arg, esp_event_base_t base,
                    int32_t id, void *data) {
    esp_mqtt_event_handle_t e = data;
    switch (id) {
    case MQTT_EVENT_CONNECTED:
        esp_mqtt_client_subscribe(e->client,
                                  "casa/salotto/led/set", 1);
        esp_mqtt_client_publish(e->client, "casa/salotto/status",
                                "online", 0, 1, true);
        break;
    case MQTT_EVENT_DATA:
        ESP_LOGI("mqtt", "%.*s = %.*s", e->topic_len, e->topic,
                 e->data_len, e->data);
        break;
    default: break;
    }
}

void avvia_mqtt(void) {
    esp_mqtt_client_config_t c = {
        .broker.address.uri = "mqtts://broker.example.com:8883",
        .broker.verification.crt_bundle_attach =
            esp_crt_bundle_attach,
        .credentials.username = "utente",
        .credentials.authentication.password = "password",
        .session.last_will = {
            .topic = "casa/salotto/status", .msg = "offline",
            .qos = 1, .retain = true },
        .session.keepalive = 30,
    };
    esp_mqtt_client_handle_t h = esp_mqtt_client_init(&c);
    esp_mqtt_client_register_event(h, ESP_EVENT_ANY_ID, on_mqtt, 0);
    esp_mqtt_client_start(h);
}
