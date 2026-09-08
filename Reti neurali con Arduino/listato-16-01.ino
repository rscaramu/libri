// listato-16-01.ino — Doppio buffer per l'audio. L'interrupt riempie un buffer; quando è pieno alza pronto e passa all'altro; il loop elabora il buffer non attivo con un secondo intero a disposizione.

#include <PDM.h>
static const int FS = 16000, N = FS;      // 1 secondo
static int16_t buf[2][N];
static volatile int attivo = 0, riempito = 0;
static volatile bool pronto = false;

void onPDM() {
  int b = PDM.available();
  int n = b / 2;
  if (riempito + n > N) n = N - riempito;
  PDM.read(buf[attivo] + riempito, n * 2);
  riempito += n;
  if (riempito >= N) {                    // secondo completo
    pronto = true; attivo ^= 1; riempito = 0;
  }
}
