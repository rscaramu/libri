// Funzioni di supporto richiamate dal nucleo del progetto.
// Ogni funzione rimanda al listato del libro che la definisce.
#pragma once
#include <Arduino.h>

bool connettiVeloce(void);   // listato 30.3
bool mqttConnetti(void);     // listato 26.1, senza il ciclo di riconnessione
