// Funzioni di supporto richiamate dal nucleo del progetto.
// Ogni funzione rimanda al listato del libro che la definisce.
#pragma once
#include <Arduino.h>

void alimentaPeriferiche(bool on);   // interruttore di carico su GPIO4
void configuraOra(void);
void leggiSHT40(float *t, float *h);
float tensioneBatteria(void);       // paragrafo 17.5
void disegnaGrafico(const int16_t *st, uint16_t idx, float t, float h, float v);
