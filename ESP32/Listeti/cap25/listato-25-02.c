// ESP32 — La guida completa alla famiglia · capitolo 25 (Rete e protocolli)
// Listato 25.2 — Un GET HTTPS in ESP-IDF con il bundle di certificati. La callback riceve il corpo a pezzi, che è il modo giusto di gestire risposte grandi.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "esp_http_client.h"
#include "esp_crt_bundle.h"

static char corpo[2048];
static int  corpo_len;

static esp_err_t on_evt(esp_http_client_event_t *e) {
    if (e->event_id == HTTP_EVENT_ON_DATA &&
        corpo_len + e->data_len < sizeof corpo) {
        memcpy(corpo + corpo_len, e->data, e->data_len);
        corpo_len += e->data_len;
    }
    return ESP_OK;
}

void scarica(void) {
    esp_http_client_config_t c = {
        .url = "https://api.example.com/dati",
        .event_handler = on_evt,
        .crt_bundle_attach = esp_crt_bundle_attach,
        .timeout_ms = 5000,
    };
    esp_http_client_handle_t h = esp_http_client_init(&c);
    corpo_len = 0;
    if (esp_http_client_perform(h) == ESP_OK) {
        corpo[corpo_len] = 0;
        ESP_LOGI("http", "%d: %s",
                 esp_http_client_get_status_code(h), corpo);
    }
    esp_http_client_cleanup(h);
}
