// ESP32 — La guida completa alla famiglia · capitolo 37 (Sette progetti, uno per famiglia)
// Listato 37.7 — Il ciclo del data logger. Il ridisegno dell'e-paper è la fase costosa e avviene una volta l'ora; la scrittura su SD dura 100 ms.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#define N_STORICO 288
RTC_DATA_ATTR int16_t storicoT[N_STORICO];    // decimi di grado
RTC_DATA_ATTR uint16_t idx = 0;
RTC_DATA_ATTR uint32_t risvegli = 0;

void setup() {
  risvegli++;
  alimentaPeriferiche(true);
  configuraOra();                     // RTC + eventuale SNTP iniziale

  float t, h;
  leggiSHT40(&t, &h);
  storicoT[idx] = (int16_t)(t * 10);
  idx = (idx + 1) % N_STORICO;

  if (SD.begin(5, SPI, 10000000)) {
    char nome[24];
    struct tm tm; getLocalTime(&tm, 0);
    strftime(nome, sizeof nome, "/%Y%m%d.csv", &tm);
    File f = SD.open(nome, FILE_APPEND);
    if (f) { f.printf("%lu,%.1f,%.0f\n",
                      (unsigned long)time(NULL), t, h); f.close(); }
    SD.end();
  }

  if (risvegli % 12 == 1) {
    display.init();
    disegnaGrafico(storicoT, idx, t, h, tensioneBatteria());
    display.display();                // ~2 s a 30 mA
    display.hibernate();
  }

  alimentaPeriferiche(false);
  esp_sleep_enable_timer_wakeup(300ULL * 1000000ULL);
  esp_deep_sleep_start();
}
