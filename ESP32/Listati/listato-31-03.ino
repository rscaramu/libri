// ESP32 — La guida completa alla famiglia · capitolo 31 (Storage)
// Listato 31.3 — LittleFS: montaggio, scrittura in append, elenco dei file. L'API `File` è la stessa di SD e di SPIFFS, quindi il codice si sposta fra i tre senza modifiche.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <LittleFS.h>

void setup() {
  Serial.begin(115200);
  if (!LittleFS.begin(true)) {         // true: formatta se corrotto
    Serial.println("LittleFS non montato");
    return;
  }
  Serial.printf("usati %u di %u byte\n",
                LittleFS.usedBytes(), LittleFS.totalBytes());

  File f = LittleFS.open("/log/misure.csv", FILE_APPEND);
  if (f) {
    f.printf("%lu,%.2f\n", (unsigned long)time(NULL), 21.5);
    f.close();
  }

  File d = LittleFS.open("/");
  for (File e = d.openNextFile(); e; e = d.openNextFile())
    Serial.printf("%s  %u\n", e.name(), e.size());
}
