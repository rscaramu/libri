// listato-09-02.ino — Lettura del microfono PDM. Ogni chiamata a onPDM porta 256 campioni a 16 kHz; il loop stampa il livello medio, che sale parlando vicino alla scheda.

#include <PDM.h>

static const int FREQ = 16000;        // Hz
short buffer[512];
volatile int letti = 0;

void onPDM() {
  int byteDisponibili = PDM.available();
  PDM.read(buffer, byteDisponibili);
  letti = byteDisponibili / 2;        // campioni a 16 bit
}

void setup() {
  Serial.begin(115200);
  while (!Serial);
  PDM.onReceive(onPDM);
  PDM.setGain(30);
  if (!PDM.begin(1, FREQ)) { Serial.println("PDM fallito"); while (1); }
}

void loop() {
  if (letti) {
    long somma = 0;
    for (int i = 0; i < letti; i++) somma += abs(buffer[i]);
    Serial.println(somma / letti);    // livello medio
    letti = 0;
  }
}
