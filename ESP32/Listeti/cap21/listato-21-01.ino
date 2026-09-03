// ESP32 — La guida completa alla famiglia · capitolo 21 (I2S e audio)
// Listato 21.1 — Un misuratore di livello con un microfono I2S a 16 kHz. `I2S_MODE_PDM_RX` al posto di `I2S_MODE_STD` per un microfono PDM.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <ESP_I2S.h>

I2SClass i2s;
int16_t campioni[512];

void setup() {
  Serial.begin(115200);
  i2s.setPins(26, 25, -1, 33);   // BCLK, WS, DOUT, DIN
  i2s.begin(I2S_MODE_STD, 16000, I2S_DATA_BIT_WIDTH_16BIT,
            I2S_SLOT_MODE_MONO);
}

void loop() {
  size_t n = i2s.readBytes((char *)campioni, sizeof(campioni));
  int32_t picco = 0;
  for (size_t i = 0; i < n / 2; i++)
    if (abs(campioni[i]) > picco) picco = abs(campioni[i]);
  Serial.println(picco);
}
