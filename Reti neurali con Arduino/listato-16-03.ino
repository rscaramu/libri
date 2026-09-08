// listato-16-03.ino — Keyword spotting continuo con la libreria di Edge Impulse. Ogni 250 ms arriva una fetta; run_classifier_continuous calcola le MFCC della fetta, le accoda a quelle delle tre precedenti, ed esegue la rete sull'ultimo secondo. La tenuta di 1,5 s evita che "accendi" scatti quattro volte.

#include <PDM.h>
#include <parola_inferencing.h>

// EI_CLASSIFIER_SLICES_PER_MODEL_WINDOW = 4 -> fette da 250 ms
static const int FETTA = EI_CLASSIFIER_SLICE_SIZE;   // 4000 campioni
static int16_t fetta[2][FETTA];
static volatile int attivo = 0, riempito = 0;
static volatile bool pronta = false;
const float SOGLIA = 0.8f;
int ultimaClasse = -1; unsigned long tenuta = 0;

void onPDM() {
  int n = PDM.available() / 2;
  if (riempito + n > FETTA) n = FETTA - riempito;
  PDM.read(fetta[attivo] + riempito, n * 2);
  riempito += n;
  if (riempito >= FETTA) { pronta = true; attivo ^= 1; riempito = 0; }
}

static int leggi(size_t off, size_t len, float* out) {
  numpy::int16_to_float(fetta[attivo ^ 1] + off, out, len);
  return 0;
}

void setup() {
  Serial.begin(115200);
  pinMode(D3, OUTPUT);                     // relè
  PDM.onReceive(onPDM); PDM.setGain(30);
  PDM.begin(1, EI_CLASSIFIER_FREQUENCY);
  run_classifier_init();
}

void loop() {
  if (!pronta) return;
  pronta = false;
  signal_t s; s.total_length = FETTA; s.get_data = &leggi;
  ei_impulse_result_t r;
  if (run_classifier_continuous(&s, &r, false) != EI_IMPULSE_OK) return;

  int m = 0;
  for (int i = 1; i < EI_CLASSIFIER_LABEL_COUNT; i++)
    if (r.classification[i].value > r.classification[m].value) m = i;
  const char* nome = r.classification[m].label;
  if (r.classification[m].value > SOGLIA && millis() > tenuta) {
    if (!strcmp(nome, "accendi")) digitalWrite(D3, HIGH);
    if (!strcmp(nome, "spegni"))  digitalWrite(D3, LOW);
    tenuta = millis() + 1500;
  }
}
