// listato 12.2 + 12.5 + 12.7 — inferenza con ArduTFLite, XIAO ESP32S3 + MPU6050
#include <Adafruit_MPU6050.h>
#include <Wire.h>
Adafruit_MPU6050 mpu;
unsigned long prossimo = 0;
#include <ArduTFLite.h>
#include "gesti_modello.h"

constexpr int kArena = 4 * 1024;
alignas(16) byte arena[kArena];
static float buffer[384];
static int pos = 0;
const char* classi[] = {"cerchio", "croce", "fermo"};

const float SOGLIA = 0.7f;
const int CONFERME = 2;
int ultima = 2, conferme = 0;
unsigned long tenutaFino = 0;

int stabilizza(int classe, float p) {
  if (p < SOGLIA) classe = 2;
  if (classe == ultima) conferme++; else { ultima = classe; conferme = 1; }
  if (classe != 2 && conferme == CONFERME && millis() > tenutaFino) { tenutaFino = millis() + 1000; return classe; }
  return -1;
}

void setup() {
  Serial.begin(115200);
  if (!mpu.begin()) while (1);
  mpu.setAccelerometerRange(MPU6050_RANGE_4_G);
  pinMode(LED_BUILTIN, OUTPUT); digitalWrite(LED_BUILTIN, HIGH);
  prossimo = micros();
  if (!modelInit(gesti_tflite, arena, kArena)) { Serial.println("modelInit fallita"); while (1); }
}

void loop() {
  if ((long)(micros() - prossimo) < 0) return;
  prossimo += 10000;
  sensors_event_t a, g, t; mpu.getEvent(&a, &g, &t);
  float x = a.acceleration.x / 9.81f, y = a.acceleration.y / 9.81f, z = a.acceleration.z / 9.81f;
  buffer[pos++] = x / 4.0f; buffer[pos++] = y / 4.0f; buffer[pos++] = z / 4.0f;
  if (pos < 384) return;

  for (int i = 0; i < 384; i++) modelSetInput(buffer[i], i);
  unsigned long t0 = micros();
  modelRunInference();
  unsigned long dt = micros() - t0;

  int migliore = 0; float p[3];
  for (int k = 0; k < 3; k++) { p[k] = modelGetOutput(k); if (p[k] > p[migliore]) migliore = k; }
  Serial.print(classi[migliore]); Serial.print(' '); Serial.print(p[migliore], 2); Serial.print("  "); Serial.print(dt); Serial.println(" us");

  int evento = stabilizza(migliore, p[migliore]);
  // un solo LED: un lampeggio per cerchio, due per croce
  for (int k = 0; k <= evento && evento >= 0; k++) { digitalWrite(LED_BUILTIN, LOW); delay(120); digitalWrite(LED_BUILTIN, HIGH); delay(120); }

  memmove(buffer, buffer + 60, (384 - 60) * sizeof(float));
  pos = 384 - 60;
}
