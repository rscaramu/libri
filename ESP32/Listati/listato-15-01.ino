// ESP32 — La guida completa alla famiglia · capitolo 15 (Clock, reset, watchdog e log)
// Listato 15.1 — Le cause di reset leggibili con `esp_reset_reason()`. Stamparla all'avvio, e magari salvarla in NVS, è il modo più economico di diagnosticare un dispositivo in campo.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <esp_system.h>

const char *causaReset(void) {
  switch (esp_reset_reason()) {
    case ESP_RST_POWERON:   return "accensione";
    case ESP_RST_EXT:       return "pin EN";
    case ESP_RST_SW:        return "ESP.restart()";
    case ESP_RST_PANIC:     return "crash software";
    case ESP_RST_INT_WDT:   return "watchdog interrupt";
    case ESP_RST_TASK_WDT:  return "watchdog task";
    case ESP_RST_WDT:       return "altro watchdog";
    case ESP_RST_DEEPSLEEP: return "risveglio";
    case ESP_RST_BROWNOUT:  return "tensione bassa";
    default:                return "sconosciuta";
  }
}
