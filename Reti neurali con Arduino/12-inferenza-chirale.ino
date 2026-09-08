// listati 12.3 + 12.4 — il runtime nudo: resolver mirato, arena, quantizzazione a mano
#include <Adafruit_MPU6050.h>
#include <Wire.h>
Adafruit_MPU6050 mpu;
unsigned long prossimo = 0;
#include <Chirale_TensorFlowLite.h>
#include <tensorflow/lite/micro/micro_mutable_op_resolver.h>
#include <tensorflow/lite/micro/micro_interpreter.h>
#include <tensorflow/lite/micro/micro_profiler.h>
#include <tensorflow/lite/schema/schema_generated.h>
#include "gesti_modello.h"

constexpr int kArena = 4 * 1024;
alignas(16) uint8_t arena[kArena];
const tflite::Model* modello = nullptr;
tflite::MicroInterpreter* interprete = nullptr;
TfLiteTensor* ingresso = nullptr;
TfLiteTensor* uscita = nullptr;
static tflite::MicroProfiler profiler;
static float buffer[384];
static int pos = 0;
const char* classi[] = {"cerchio", "croce", "fermo"};

void setup() {
  Serial.begin(115200);
  while (!Serial);
  if (!mpu.begin()) while (1);
  mpu.setAccelerometerRange(MPU6050_RANGE_4_G);
  prossimo = micros();
  modello = tflite::GetModel(gesti_tflite);
  if (modello->version() != TFLITE_SCHEMA_VERSION) { Serial.println("versione del modello non supportata"); while (1); }
  static tflite::MicroMutableOpResolver<2> resolver;
  resolver.AddFullyConnected();
  resolver.AddSoftmax();
  static tflite::MicroInterpreter interp(modello, resolver, arena, kArena, nullptr, &profiler);
  interprete = &interp;
  if (interprete->AllocateTensors() != kTfLiteOk) { Serial.println("AllocateTensors fallita: arena troppo piccola"); while (1); }
  ingresso = interprete->input(0);
  uscita = interprete->output(0);
  Serial.print("arena usata: "); Serial.println(interprete->arena_used_bytes());
  Serial.print("scala ingresso: "); Serial.print(ingresso->params.scale, 5);
  Serial.print("  zero point: "); Serial.println(ingresso->params.zero_point);
}

void loop() {
  if ((long)(micros() - prossimo) < 0) return;
  prossimo += 10000;
  sensors_event_t a, g, t; mpu.getEvent(&a, &g, &t);
  float x = a.acceleration.x / 9.81f, y = a.acceleration.y / 9.81f, z = a.acceleration.z / 9.81f;
  buffer[pos++] = x / 4.0f; buffer[pos++] = y / 4.0f; buffer[pos++] = z / 4.0f;
  if (pos < 384) return;

  float s = ingresso->params.scale; int zp = ingresso->params.zero_point;
  for (int i = 0; i < 384; i++) {
    int q = (int)roundf(buffer[i] / s) + zp;
    if (q < -128) q = -128; if (q > 127) q = 127;
    ingresso->data.int8[i] = (int8_t)q;
  }
  unsigned long t0 = micros();
  if (interprete->Invoke() != kTfLiteOk) return;
  unsigned long dt = micros() - t0;
  float so = uscita->params.scale; int zo = uscita->params.zero_point;
  float p[3]; int migliore = 0;
  for (int k = 0; k < 3; k++) { p[k] = (uscita->data.int8[k] - zo) * so; if (p[k] > p[migliore]) migliore = k; }
  Serial.print(classi[migliore]); Serial.print(' '); Serial.print(p[migliore], 2); Serial.print("  "); Serial.print(dt); Serial.println(" us");
  static int n = 0;
  if (++n == 10) { profiler.Log(); Serial.print("arena usata dopo Invoke: "); Serial.println(interprete->arena_used_bytes()); }
  memmove(buffer, buffer + 60, (384 - 60) * sizeof(float));
  pos = 384 - 60;
}
