// ESP32 — La guida completa alla famiglia · capitolo 37 (Sette progetti, uno per famiglia)
// Listato 37.5 — Il sensore Zigbee a batteria con la libreria Arduino. Il risveglio è sul fronte opposto allo stato attuale, così ogni cambio sveglia il chip.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include <Zigbee.h>

#define PIN_REED 3
ZigbeeContactSwitch contatto(10);

void setup() {
  pinMode(PIN_REED, INPUT_PULLUP);
  bool aperto = digitalRead(PIN_REED);

  contatto.setManufacturerAndModel("Io", "PortaH2");
  contatto.setPowerSource(ZB_POWER_SOURCE_BATTERY, leggiBatteria());
  Zigbee.addEndpoint(&contatto);
  Zigbee.setRebootOpenNetwork(180);
  Zigbee.setTimeout(10000);
  if (!Zigbee.begin(ZIGBEE_END_DEVICE)) ESP.restart();
  uint32_t t0 = millis();
  while (!Zigbee.connected() && millis() - t0 < 10000) delay(20);

  if (Zigbee.connected()) {
    contatto.setOpen(aperto);
    delay(150);                         // lascia partire il rapporto
  }

  esp_sleep_enable_ext1_wakeup(BIT64(PIN_REED),
      aperto ? ESP_EXT1_WAKEUP_ANY_LOW : ESP_EXT1_WAKEUP_ANY_HIGH);
  esp_sleep_enable_timer_wakeup(3600ULL * 1000000ULL);
  esp_deep_sleep_start();
}

void loop() {}
