// ESP32 — La guida completa alla famiglia · capitolo 33 (OTA)
// Listato 33.4 — OTA da HTTPS in ESP-IDF con controllo della versione prima di scrivere. La versione viene dal `CMakeLists.txt` (`PROJECT_VER`) o da un file `version.txt` nel progetto.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "esp_https_ota.h"
#include "esp_app_desc.h"
#include "esp_crt_bundle.h"

static esp_err_t controlla_versione(esp_app_desc_t *nuova) {
    const esp_app_desc_t *attuale = esp_app_get_description();
    if (strcmp(nuova->version, attuale->version) <= 0)
        return ESP_FAIL;              // stessa o più vecchia
    return ESP_OK;
}

void aggiorna(void) {
    esp_http_client_config_t http = {
        .url = "https://fw.example.com/salotto/latest.bin",
        .crt_bundle_attach = esp_crt_bundle_attach,
        .timeout_ms = 10000,
    };
    esp_https_ota_config_t ota = { .http_config = &http };
    esp_https_ota_handle_t h;
    if (esp_https_ota_begin(&ota, &h) != ESP_OK) return;

    esp_app_desc_t desc;
    esp_https_ota_get_img_desc(h, &desc);
    if (controlla_versione(&desc) != ESP_OK) {
        esp_https_ota_abort(h); return;
    }
    while (esp_https_ota_perform(h) == ESP_ERR_HTTPS_OTA_IN_PROGRESS)
        ;                              // o aggiorna una barra
    if (esp_https_ota_finish(h) == ESP_OK) esp_restart();
}
