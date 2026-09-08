// listato 9.3 — hello world: una rete che approssima il seno (modello dall'esempio ArduTFLite)
#include <ArduTFLite.h>
#include "modello_seno.h"
constexpr int kArena = 2 * 1024;
alignas(16) byte arena[kArena];
void setup() {
  Serial.begin(115200);
  while (!Serial);
  if (!modelInit(modello_seno, arena, kArena)) { Serial.println("modelInit fallita"); while (1); }
  Serial.println("x, seno reale, seno della rete");
}
void loop() {
  static float x = 0;
  modelSetInput(x, 0);
  if (!modelRunInference()) { Serial.println("errore"); return; }
  float y = modelGetOutput(0);
  Serial.print(x, 3); Serial.print(", "); Serial.print(sin(x), 3); Serial.print(", "); Serial.println(y, 3);
  x += 0.1; if (x > 6.28) x = 0;
  delay(50);
}
