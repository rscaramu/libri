// ESP32 — La guida completa alla famiglia · capitolo 35 (Debug e collaudo)
// Listato 35.1 — Lettura del riepilogo del core dump al riavvio. L'immagine completa si legge con `esp_core_dump_image_get()` e si spedisce come blob.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_core_dump.h>

void setup() {
  esp_core_dump_init();
  esp_core_dump_summary_t sum;
  if (esp_core_dump_get_summary(&sum) == ESP_OK) {
    Serial.printf("crash in task %s, PC 0x%08x, causa %d\n",
                  sum.exc_task, sum.exc_pc, sum.ex_info.exc_cause);
    // qui: invia sum, o l'intera partizione, al server
    esp_core_dump_image_erase();
  }
}
