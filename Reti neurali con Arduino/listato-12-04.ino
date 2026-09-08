// listato-12-04.ino — Quantizzazione dell'ingresso e dequantizzazione dell'uscita. Due righe ciascuna; dimenticarle, o usare una scala sbagliata, produce un modello che risponde a caso senza nessun errore.

void loop() {
  // ... riempimento del buffer come nel listato 12.2 ...
  float s = ingresso->params.scale;
  int   z = ingresso->params.zero_point;
  for (int i = 0; i < 384; i++) {
    int q = (int)roundf(buffer[i] / s) + z;
    if (q < -128) q = -128; if (q > 127) q = 127;
    ingresso->data.int8[i] = (int8_t)q;
  }
  if (interprete->Invoke() != kTfLiteOk) return;
  float so = uscita->params.scale; int zo = uscita->params.zero_point;
  for (int k = 0; k < 3; k++)
    p[k] = (uscita->data.int8[k] - zo) * so;
  // ... scelta della classe e stampa come nel listato 12.2 ...
}
