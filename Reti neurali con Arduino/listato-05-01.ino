// listato-05-01.ino — Inferenza completa di una rete 4→8→3 senza librerie. I pesi sono quelli addestrati in Keras su Iris (accuratezza 0,987), arrotondati a tre decimali; lo script che li produce è nel repository. Gira su qualsiasi scheda, UNO compreso.

// Rete 4-8-3 per Iris. Pesi addestrati in Keras, arrotondati.
const float W1[4][8] = {
  {-0.321, 0.402,-0.152,-0.527,-0.040,-0.668,-0.921, 0.220},
  { 0.272, 1.180, 0.218,-0.248,-0.081,-0.495,-1.324,-0.508},
  {-0.378,-1.351,-0.348,-0.691, 0.006,-0.673, 1.879,-0.364},
  {-0.507,-1.121,-0.281,-0.226,-0.075, 0.525, 3.121,-0.656}};
const float b1[8] = {-0.111, 0.491, 0.000, 0.000,-0.041, 0.000,
                     -3.242, 0.000};
const float W2[8][3] = {
  {-0.443,-0.223,-0.185},{ 1.390,-2.946,-1.098},{ 0.007, 0.067, 0.455},
  {-0.390,-0.320,-0.329},{-0.498, 0.573,-0.537},{-0.318,-0.186, 0.121},
  {-1.996,-1.855, 2.240},{-0.594,-0.442, 0.532}};
const float b2[3] = {-2.525, 4.081,-2.999};

int inferisci(const float x[4], float p[3]) {
  float h[8];
  for (int j = 0; j < 8; j++) {            // strato denso + ReLU
    float s = b1[j];
    for (int i = 0; i < 4; i++) s += W1[i][j] * x[i];
    h[j] = s > 0 ? s : 0;
  }
  float z[3], somma = 0;
  for (int k = 0; k < 3; k++) {            // strato denso + softmax
    float s = b2[k];
    for (int j = 0; j < 8; j++) s += W2[j][k] * h[j];
    z[k] = exp(s); somma += z[k];
  }
  int migliore = 0;
  for (int k = 0; k < 3; k++) {
    p[k] = z[k] / somma;
    if (p[k] > p[migliore]) migliore = k;
  }
  return migliore;        // 0 setosa, 1 versicolor, 2 virginica
}

void setup() {
  Serial.begin(115200);
  const float fiore[4] = {5.1, 3.5, 1.4, 0.2};   // una setosa
  float p[3];
  int c = inferisci(fiore, p);
  Serial.print("classe "); Serial.print(c);
  Serial.print("  p = "); Serial.print(p[0], 2);
  Serial.print(' ');       Serial.print(p[1], 2);
  Serial.print(' ');       Serial.println(p[2], 2);
}
void loop() {}
