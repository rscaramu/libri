// listato-12-02.ino — Inferenza con ArduTFLite e il modello Keras. modelSetInput riceve il valore float e lo quantizza con scala e zero point letti dal modello; modelGetOutput fa l'inverso sull'uscita.

#include <Arduino_BMI270_BMM150.h>
#include <ArduTFLite.h>
#include "gesti_modello.h"

constexpr int kArena = 4 * 1024;
alignas(16) byte arena[kArena];
static float buffer[384];
static int pos = 0;
const char* classi[] = {"cerchio", "croce", "fermo"};

void setup() {
  Serial.begin(115200);
  if (!IMU.begin()) while (1);
  if (!modelInit(gesti_tflite, arena, kArena)) {
    Serial.println("modelInit fallita"); while (1);
  }
}

void loop() {
  float x, y, z;
  if (!IMU.accelerationAvailable()) return;
  IMU.readAcceleration(x, y, z);
  buffer[pos++] = x / 4.0f;               // la stessa riga di Keras
  buffer[pos++] = y / 4.0f;
  buffer[pos++] = z / 4.0f;
  if (pos < 384) return;

  for (int i = 0; i < 384; i++) modelSetInput(buffer[i], i);
  unsigned long t0 = micros();
  modelRunInference();
  unsigned long dt = micros() - t0;

  int migliore = 0; float p[3];
  for (int k = 0; k < 3; k++) {
    p[k] = modelGetOutput(k);
    if (p[k] > p[migliore]) migliore = k;
  }
  Serial.print(classi[migliore]); Serial.print(' ');
  Serial.print(p[migliore], 2);  Serial.print("  ");
  Serial.print(dt); Serial.println(" us");

  memmove(buffer, buffer + 60, (384 - 60) * sizeof(float));
  pos = 384 - 60;
}
