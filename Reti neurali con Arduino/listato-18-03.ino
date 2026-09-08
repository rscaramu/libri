// listato-18-03.ino — La visione in un task FreeRTOS sul secondo core dell'S3. Il task dorme finché non riceve la notifica, classifica dieci frame, risponde, e torna a dormire; il loop sul primo core continua a servire seriale e Wi-Fi.

TaskHandle_t taskVisione;
volatile float ultimaPersona = 0;

void visione(void*) {
  for (;;) {
    ulTaskNotifyTake(pdTRUE, portMAX_DELAY);     // aspetta SVEGLIA
    float somma = 0;
    for (int i = 0; i < 10; i++) somma += classificaFrame(); // cap. 17
    ultimaPersona = somma / 10;
    Serial1.printf("PERSONA %.2f\n", ultimaPersona);
  }
}

void setup() {
  // ...
  xTaskCreatePinnedToCore(visione, "visione", 8192, nullptr, 1,
                          &taskVisione, 1);          // core 1
}

// nel parser della seriale, alla ricezione di SVEGLIA:
//   xTaskNotifyGive(taskVisione);
