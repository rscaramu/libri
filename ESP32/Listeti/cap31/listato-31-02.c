// ESP32 — La guida completa alla famiglia · capitolo 31 (Storage)
// Listato 31.2 — NVS in ESP-IDF. `nvs_commit` rende permanenti le scritture; `Preferences` lo chiama da sola. I due errori all'inizializzazione si gestiscono cancellando la partizione, cosa che succede dopo un cambio di versione del formato.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "nvs_flash.h"
#include "nvs.h"

esp_err_t r = nvs_flash_init();
if (r == ESP_ERR_NVS_NO_FREE_PAGES ||
    r == ESP_ERR_NVS_NEW_VERSION_FOUND) {
    nvs_flash_erase();                 // partizione da rifare
    nvs_flash_init();
}

nvs_handle_t h;
nvs_open("config", NVS_READWRITE, &h);
uint32_t avvii = 0;
nvs_get_u32(h, "avvii", &avvii);       // ESP_ERR_NVS_NOT_FOUND = 0
nvs_set_u32(h, "avvii", avvii + 1);
size_t len = 64; char broker[64];
if (nvs_get_str(h, "broker", broker, &len) != ESP_OK)
    strcpy(broker, "192.168.1.10");
nvs_commit(h);
nvs_close(h);
