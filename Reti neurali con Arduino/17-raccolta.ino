// listato 17.2 — raccolta immagini su microSD in formato PGM, una cartella per classe
#include "esp_camera.h"
#include "SD.h"
#include "camera_xiao.h"
int classe = 0, contatore = 0;
const char* nomi[] = {"tazza", "chiavi", "telefono", "vuoto"};
void scatta() {
  camera_fb_t* fb = esp_camera_fb_get();
  if (!fb) return;
  char nome[40];
  snprintf(nome, sizeof nome, "/%s/%s_%03d.pgm", nomi[classe], nomi[classe], contatore++);
  File f = SD.open(nome, FILE_WRITE);
  f.printf("P5\n%d %d\n255\n", fb->width, fb->height);
  f.write(fb->buf, fb->len);
  f.close();
  esp_camera_fb_return(fb);
}
void setup() {
  Serial.begin(115200);
  if (!avviaCamera()) { Serial.println("camera"); while (1); }
  if (!SD.begin(21)) { Serial.println("microSD"); while (1); }
  for (auto n : nomi) SD.mkdir(String("/") + n);
  pinMode(D1, INPUT_PULLUP); pinMode(D2, INPUT_PULLUP);
}
void loop() {
  if (!digitalRead(D1)) { scatta(); delay(300); }
  if (!digitalRead(D2)) { classe = (classe + 1) % 4; contatore = 0; Serial.println(nomi[classe]); delay(300); }
}
