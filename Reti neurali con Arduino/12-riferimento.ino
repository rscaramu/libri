// paragrafo 12.5 — test di riferimento: una finestra nota da Python, l'uscita deve coincidere al byte
#include <Chirale_TensorFlowLite.h>
#include <tensorflow/lite/micro/micro_mutable_op_resolver.h>
#include <tensorflow/lite/micro/micro_interpreter.h>
#include <tensorflow/lite/schema/schema_generated.h>
#include "gesti_modello.h"
#include "gesti_riferimento.h"
constexpr int kArena = 4 * 1024;
alignas(16) uint8_t arena[kArena];
void setup() {
  Serial.begin(115200);
  while (!Serial);
  const tflite::Model* m = tflite::GetModel(gesti_tflite);
  static tflite::MicroMutableOpResolver<2> r; r.AddFullyConnected(); r.AddSoftmax();
  static tflite::MicroInterpreter it(m, r, arena, kArena);
  if (it.AllocateTensors() != kTfLiteOk) { Serial.println("arena"); while (1); }
  memcpy(it.input(0)->data.int8, rifIngresso, 384);
  it.Invoke();
  bool ok = true;
  for (int k = 0; k < 3; k++) { Serial.print((int)it.output(0)->data.int8[k]); Serial.print(" attesa "); Serial.println((int)rifUscita[k]); ok &= it.output(0)->data.int8[k] == rifUscita[k]; }
  Serial.println(ok ? "OK: la catena coincide con Python" : "DIVERSO: controlla scala, ordine, normalizzazione");
  Serial.print("arena usata: "); Serial.println(it.arena_used_bytes());
}
void loop() {}
