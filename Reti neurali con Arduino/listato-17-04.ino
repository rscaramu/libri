// listato-17-04.ino — Classificazione di immagini con la libreria di Edge Impulse. La funzione leggi converte il pixel grigio nel formato a 24 bit che il blocco immagine di Studio si aspetta; la libreria fa il resto. La stampa dice quanto costa ogni fase.

#include <oggetti_inferencing.h>
#include "esp_camera.h"
#include "esp_heap_caps.h"

static uint8_t img[96 * 96];              // SRAM, 9 KB
const char* nomi[] = {"chiavi", "tazza", "telefono", "vuoto"};

static int leggi(size_t off, size_t len, float* out) {
  for (size_t i = 0; i < len; i++) {
    uint8_t p = img[off + i];
    out[i] = (p << 16) | (p << 8) | p;    // il DSP di EI vuole RGB888
  }
  return 0;
}

void setup() {
  Serial.begin(115200);
  if (!avviaCamera()) while (1);
  Serial.printf("SRAM contigua: %u\n",
    heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL));
}

void loop() {
  camera_fb_t* fb = esp_camera_fb_get();
  if (!fb) return;
  ritagliaERiduci(fb->buf, fb->width, fb->height, img);   // 2 ms
  esp_camera_fb_return(fb);

  signal_t s; s.total_length = 96 * 96; s.get_data = &leggi;
  ei_impulse_result_t r;
  unsigned long t0 = millis();
  if (run_classifier(&s, &r, false) != EI_IMPULSE_OK) return;
  int m = 0;
  for (int i = 1; i < EI_CLASSIFIER_LABEL_COUNT; i++)
    if (r.classification[i].value > r.classification[m].value) m = i;
  Serial.printf("%-9s %.2f  %lu ms  (dsp %d, nn %d)\n",
    r.classification[m].label, r.classification[m].value,
    millis() - t0, r.timing.dsp, r.timing.classification);
}
