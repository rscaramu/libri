// listato-15-04.ino — Inferenza con l'autoencoder. La differenza dai progetti precedenti è l'ultimo ciclo: l'uscita non è una classe ma la ricostruzione, e il risultato è l'errore fra le due. Per semplicità la scheda usa il modulo dell'accelerazione al posto della media dei tre spettri.

#include <ArduTFLite.h>
#include "ae_modello.h"
#include "ae_norm.h"                     // mu[64], sd[64], SOGLIA
#include <arduinoFFT.h>

float vReale[256], vImm[256], spettro[64], ricostr[64];
ArduinoFFT<float> fft(vReale, vImm, 256, 100.0);
alignas(16) byte arena[4 * 1024];

float punteggio() {
  // vReale contiene il modulo dell'accelerazione, media tolta
  memset(vImm, 0, sizeof(vImm));
  fft.windowing(FFTWindow::Hann, FFTDirection::Forward);
  fft.compute(FFTDirection::Forward);
  fft.complexToMagnitude();
  for (int i = 0; i < 64; i++) {
    spettro[i] = (log1pf(vReale[i + 1]) - mu[i]) / sd[i];
    modelSetInput(spettro[i], i);
  }
  modelRunInference();
  float err = 0;
  for (int i = 0; i < 64; i++) {
    float d = modelGetOutput(i) - spettro[i]; err += d * d;
  }
  return err / 64;
}
