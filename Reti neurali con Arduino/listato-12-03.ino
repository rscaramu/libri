// listato-12-03.ino — Il setup con le classi del runtime. Il resolver registra solo FullyConnected e Softmax: il binario scende di oltre 200 KB rispetto ad ArduTFLite, che registra tutte le op: 175 KB contro 382 KB sulla Nano, misurati. arena_used_bytes dice quanta arena serve davvero.

#include <Chirale_TensorFlowLite.h>
#include "gesti_modello.h"

constexpr int kArena = 4 * 1024;
alignas(16) uint8_t arena[kArena];

const tflite::Model* modello = nullptr;
tflite::MicroInterpreter* interprete = nullptr;
TfLiteTensor* ingresso = nullptr;
TfLiteTensor* uscita = nullptr;

void setup() {
  Serial.begin(115200);
  modello = tflite::GetModel(gesti_tflite);
  if (modello->version() != TFLITE_SCHEMA_VERSION) {
    Serial.println("versione del modello non supportata"); while (1);
  }
  // Solo le op che il modello usa: Flash minima.
  static tflite::MicroMutableOpResolver<2> resolver;
  resolver.AddFullyConnected();
  resolver.AddSoftmax();

  static tflite::MicroInterpreter interp(modello, resolver,
                                         arena, kArena);
  interprete = &interp;
  if (interprete->AllocateTensors() != kTfLiteOk) {
    Serial.println("AllocateTensors fallita: arena troppo piccola");
    while (1);
  }
  ingresso = interprete->input(0);
  uscita   = interprete->output(0);
  Serial.print("arena usata: ");
  Serial.println(interprete->arena_used_bytes());
  Serial.print("scala ingresso: ");
  Serial.print(ingresso->params.scale, 5);
  Serial.print("  zero point: ");
  Serial.println(ingresso->params.zero_point);
}
