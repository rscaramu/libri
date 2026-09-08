// listato-08-01.ino — Lo sketch minimo con ArduTFLite: quattro funzioni, modelInit, modelSetInput, modelRunInference, modelGetOutput. La quantizzazione dell'ingresso e dell'uscita è fatta dalla libreria; il capitolo 12 mostra la stessa cosa con le classi del runtime, riga per riga.

#include <ArduTFLite.h>
#include "modello.h"                  // l'array del capitolo 7

constexpr int kArena = 4 * 1024;
alignas(16) byte arena[kArena];

void setup() {
  Serial.begin(115200);
  if (!modelInit(modello_tflite, arena, kArena)) {
    Serial.println("modelInit fallita: arena?"); while (1);
  }
}

void loop() {
  for (int i = 0; i < 384; i++) modelSetInput(feature[i], i);
  if (!modelRunInference()) {
    Serial.println("Invoke fallita"); return;
  }
  for (int k = 0; k < 3; k++) Serial.println(modelGetOutput(k), 3);
  delay(1000);
}
