// listato-17-02.ino — Raccolta immagini su microSD. Ogni scatto salva un file PGM, il formato più semplice che esista (intestazione di testo e byte grezzi), in una cartella per classe. Studio importa le cartelle e usa il nome come etichetta.

#include "SD.h"
int classe = 0, contatore = 0;
const char* nomi[] = {"tazza", "chiavi", "telefono", "vuoto"};

void scatta() {
  camera_fb_t* fb = esp_camera_fb_get();
  if (!fb) return;
  char nome[40];
  snprintf(nome, sizeof nome, "/%s/%s_%03d.pgm",
           nomi[classe], nomi[classe], contatore++);
  File f = SD.open(nome, FILE_WRITE);
  f.printf("P5\n%d %d\n255\n", fb->width, fb->height);  // PGM
  f.write(fb->buf, fb->len);
  f.close();
  esp_camera_fb_return(fb);           // restituire sempre il frame
}

void setup() {
  Serial.begin(115200);
  avviaCamera();
  SD.begin(21);                       // CS della microSD sulla XIAO
  for (auto n : nomi) SD.mkdir(String("/") + n);
  pinMode(D1, INPUT_PULLUP);                // scatto
  pinMode(D2, INPUT_PULLUP);                // classe successiva
}

void loop() {
  if (!digitalRead(D1)) { scatta(); delay(300); }
  if (!digitalRead(D2)) { classe = (classe + 1) % 4; contatore = 0;
                          Serial.println(nomi[classe]); delay(300); }
}
