// ESP32 — La guida completa alla famiglia · capitolo 31 (Storage)
// Frammento — Log persistenti
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

void logRiga(const char *msg) {
  static char buf[1024];
  static size_t n = 0;
  int w = snprintf(buf + n, sizeof buf - n, "%lu %s\n",
                   (unsigned long)time(NULL), msg);
  if (w > 0) n += w;
  if (n > sizeof buf - 128) logFlush();
}

void logFlush(void) {
  // scrive buf su LittleFS in append, ruota se > 64 KB, azzera n
}
