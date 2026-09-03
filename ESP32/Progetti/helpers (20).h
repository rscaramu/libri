// Funzioni di supporto richiamate dal nucleo del progetto.
// Ogni funzione rimanda al listato del libro che la definisce.
#pragma once
#include <Arduino.h>

void gestisciRete(void);     // listato 24.2
bool connettiMqtt(void);     // listato 26.1
float leggiDS18B20(void);    // DallasTemperature, un sensore sul bus
#define PIN_RELE 26
#define PIN_PULSANTE 27
