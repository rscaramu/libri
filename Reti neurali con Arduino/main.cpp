// main.cpp — frammento 17.— reso progetto: cattura, riduzione a 96x96, inferenza con ESP-DL da partizione "model".
// Il modello .espdl si ottiene con: esp-dl/tools/quantization (ONNX -> espdl); il .onnx da Keras con tf2onnx.
// Codice "strutturale": da leggere accanto agli esempi di esp-dl (examples/mobilenet_v2) della versione in uso.
#include <cstdio>
#include "esp_camera.h"
#include "esp_timer.h"
#include "dl_model_base.hpp"

extern bool avviaCamera();                                 // come camera_xiao.h, in versione ESP-IDF
extern void ritagliaERiduci(const uint8_t*, int, int, uint8_t*);
static uint8_t img[96 * 96];

extern "C" void app_main() {
  if (!avviaCamera()) { printf("camera\n"); return; }
  dl::Model modello("model", fbs::MODEL_LOCATION_IN_FLASH_PARTITION);
  for (;;) {
    camera_fb_t* fb = esp_camera_fb_get();
    if (!fb) continue;
    ritagliaERiduci(fb->buf, fb->width, fb->height, img);
    esp_camera_fb_return(fb);
    int64_t t0 = esp_timer_get_time();
    dl::TensorBase* in = modello.get_input();
    in->assign(img, 96 * 96);                                 // int8 già quantizzati (scala del modello)
    modello.run();
    dl::TensorBase* out = modello.get_output();
    int classe = out->argmax();
    printf("classe %d  %lld ms\n", classe, (esp_timer_get_time() - t0) / 1000);
  }
}
