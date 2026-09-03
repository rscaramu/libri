// ESP32 — La guida completa alla famiglia · capitolo 31 (Storage)
// Listato 31.1 — Lettura e scrittura in NVS. Le chiavi sono limitate a 15 caratteri; i namespace separano le impostazioni di moduli diversi.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <Preferences.h>
Preferences prefs;

void setup() {
  prefs.begin("config", false);          // namespace, lettura/scrittura
  uint32_t avvii = prefs.getUInt("avvii", 0) + 1;
  prefs.putUInt("avvii", avvii);
  float soglia = prefs.getFloat("soglia", 22.5f);
  String broker = prefs.getString("broker", "192.168.1.10");
  prefs.end();
}
