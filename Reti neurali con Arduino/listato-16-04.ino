// listato-16-04.ino — Il microfono della XIAO ESP32S3 Sense. La lettura è bloccante e a polling, non a interrupt: il loop legge una fetta intera, poi la classifica. Con una fetta da 250 ms e un'inferenza da 3 ms non si perde nulla.

#include <ESP_I2S.h>
I2SClass I2S;

void setup() {
  I2S.setPinsPdmRx(42, 41);               // CLK, DATA sulla XIAO Sense
  if (!I2S.begin(I2S_MODE_PDM_RX, 16000,
                 I2S_DATA_BIT_WIDTH_16BIT, I2S_SLOT_MODE_MONO))
    while (1);
}

// nel loop, al posto dell'interrupt PDM:
//   int n = I2S.readBytes((char*)fetta[attivo], FETTA * 2) / 2;
