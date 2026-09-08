// frammento-20-11.ino — Il profiler del runtime. Log stampa il tempo di ogni op nell'ordine di esecuzione; con Chirale_TensorFlowLite l'header è incluso e basta passare il profiler al costruttore.

#include "tensorflow/lite/micro/micro_profiler.h"
static tflite::MicroProfiler profiler;
static tflite::MicroInterpreter interp(modello, resolver, arena,
                                       kArena, nullptr, &profiler);
// ... dopo Invoke():
profiler.Log();          // una riga per op, con i microsecondi
