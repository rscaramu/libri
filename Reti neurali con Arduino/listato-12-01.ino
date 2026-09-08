// listato-12-01.ino — Inferenza con la libreria di Edge Impulse. La libreria calcola le feature e chiama il runtime dentro run_classifier; lo sketch riempie il buffer, invoca, e fa scorrere la finestra di 20 campioni (200 ms) alla volta.

#include <Arduino_BMI270_BMM150.h>
#include <gesti_inferencing.h>

// EI_CLASSIFIER_RAW_SAMPLE_COUNT = 128, ..._PER_FRAME = 3
static float buffer[EI_CLASSIFIER_DSP_INPUT_FRAME_SIZE];  // 384
static int   pos = 0;

void setup() {
  Serial.begin(115200);
  if (!IMU.begin()) while (1);
  pinMode(LEDR, OUTPUT); pinMode(LEDG, OUTPUT); pinMode(LEDB, OUTPUT);
}

void loop() {
  float x, y, z;
  if (!IMU.accelerationAvailable()) return;
  IMU.readAcceleration(x, y, z);
  buffer[pos++] = x; buffer[pos++] = y; buffer[pos++] = z;
  if (pos < EI_CLASSIFIER_DSP_INPUT_FRAME_SIZE) return;

  signal_t segnale;
  numpy::signal_from_buffer(buffer,
      EI_CLASSIFIER_DSP_INPUT_FRAME_SIZE, &segnale);
  ei_impulse_result_t ris;
  if (run_classifier(&segnale, &ris, false) != EI_IMPULSE_OK) return;

  int migliore = 0;
  for (int i = 1; i < EI_CLASSIFIER_LABEL_COUNT; i++)
    if (ris.classification[i].value >
        ris.classification[migliore].value) migliore = i;
  Serial.print(ris.classification[migliore].label);
  Serial.print(' ');
  Serial.print(ris.classification[migliore].value, 2);
  Serial.print("  dsp "); Serial.print(ris.timing.dsp);
  Serial.print(" ms  nn "); Serial.print(ris.timing.classification);
  Serial.println(" ms");

  // scorrimento: tieni gli ultimi 108 campioni (finestra - 200 ms)
  memmove(buffer, buffer + 60, (384 - 60) * sizeof(float));
  pos = 384 - 60;
}
