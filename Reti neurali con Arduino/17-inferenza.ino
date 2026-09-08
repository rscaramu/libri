// capitolo 17 — classificazione di immagini 96x96 con MobileNetV2 0.35 int8, runtime nudo, arena in SRAM interna
#include "esp_camera.h"
#include "esp_heap_caps.h"
#include <Chirale_TensorFlowLite.h>
#include <tensorflow/lite/micro/micro_mutable_op_resolver.h>
#include <tensorflow/lite/micro/micro_interpreter.h>
#include <tensorflow/lite/schema/schema_generated.h>
#include "camera_xiao.h"
#include "oggetti_modello.h"

constexpr int kArena = 200 * 1024;
uint8_t* arena = nullptr;                         // allocata in SRAM interna nel setup
static uint8_t img[96 * 96];
const char* nomi[] = {"chiavi", "tazza", "telefono", "vuoto"};
tflite::MicroInterpreter* interprete; TfLiteTensor* ingresso; TfLiteTensor* uscita;

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.printf("SRAM contigua prima: %u\n", heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL));
  arena = (uint8_t*)heap_caps_aligned_alloc(16, kArena, MALLOC_CAP_INTERNAL | MALLOC_CAP_8BIT);
  if (!arena) { Serial.println("arena non allocabile in SRAM interna: riduci kArena"); while (1); }
  if (!avviaCamera()) { Serial.println("camera"); while (1); }
  const tflite::Model* m = tflite::GetModel(oggetti_tflite);
  static tflite::MicroMutableOpResolver<8> r;
  r.AddConcatenation(); r.AddConv2D(); r.AddDepthwiseConv2D(); r.AddAdd(); r.AddMean(); r.AddFullyConnected(); r.AddSoftmax(); r.AddPad();
  static tflite::MicroInterpreter it(m, r, arena, kArena);
  interprete = &it;
  if (it.AllocateTensors() != kTfLiteOk) { Serial.println("AllocateTensors fallita"); while (1); }
  ingresso = it.input(0); uscita = it.output(0);
  Serial.printf("arena usata: %u  SRAM contigua dopo: %u\n", it.arena_used_bytes(), heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL));
}

void loop() {
  camera_fb_t* fb = esp_camera_fb_get();
  if (!fb) return;
  unsigned long t0 = millis();
  ritagliaERiduci(fb->buf, fb->width, fb->height, img);
  esp_camera_fb_return(fb);
  float s = ingresso->params.scale; int zp = ingresso->params.zero_point;
  for (int i = 0; i < 96 * 96; i++) { int q = (int)roundf((img[i] / 255.0f) / s) + zp; ingresso->data.int8[i] = (int8_t)constrain(q, -128, 127); }
  unsigned long t1 = millis();
  if (interprete->Invoke() != kTfLiteOk) { Serial.println("Invoke"); return; }
  unsigned long t2 = millis();
  float so = uscita->params.scale; int zo = uscita->params.zero_point; int m = 0; float p[4];
  for (int k = 0; k < 4; k++) { p[k] = (uscita->data.int8[k] - zo) * so; if (p[k] > p[m]) m = k; }
  Serial.printf("%-9s %.2f  pre %lu ms  nn %lu ms\n", nomi[m], p[m], t1 - t0, t2 - t1);
}
