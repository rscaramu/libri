// Progetto 37.1 — Il nucleo del sensore. `connettiVeloce()` è il listato 30.3; `mqttConnetti()` il 26.1 senza il ciclo di riconnessione. Un ciclo completo con trasmissione dura circa 900 ms.
// Nucleo del programma come nel libro. Le funzioni di supporto sono in helpers.h.

#include "helpers.h"

#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include <Adafruit_BME280.h>
#include <esp_sleep.h>

#define PIN_POWER 5
#define PIN_BATT  2
#define CICLO_S   600

RTC_DATA_ATTR uint8_t  canale = 0;
RTC_DATA_ATTR uint8_t  bssid[6];
RTC_DATA_ATTR float    ultimaT = -100, ultimaH = -100;
RTC_DATA_ATTR uint32_t cicli = 0;

Adafruit_BME280 bme;
WiFiClient net;
PubSubClient mqtt(net);

void dormi(void) {
  digitalWrite(PIN_POWER, HIGH);          // P-MOSFET: alto = spento
  gpio_hold_en((gpio_num_t)PIN_POWER);
  esp_sleep_enable_timer_wakeup(CICLO_S * 1000000ULL);
  esp_deep_sleep_start();
}

void setup() {
  cicli++;
  pinMode(PIN_POWER, OUTPUT);
  gpio_hold_dis((gpio_num_t)PIN_POWER);
  digitalWrite(PIN_POWER, LOW);           // accende il sensore
  delay(5);
  Wire.begin(6, 7);
  if (!bme.begin(0x76)) dormi();
  bme.setSampling(Adafruit_BME280::MODE_FORCED);
  bme.takeForcedMeasurement();
  float t = bme.readTemperature();
  float h = bme.readHumidity();
  float p = bme.readPressure() / 100.0f;
  uint32_t mv = 0;
  for (int i = 0; i < 16; i++) mv += analogReadMilliVolts(PIN_BATT);
  float vbat = mv / 16 * 2 / 1000.0f;

  bool cambia = fabsf(t - ultimaT) > 0.3f || fabsf(h - ultimaH) > 2;
  if (!cambia && cicli % 6 != 0) dormi();

  if (connettiVeloce() && mqttConnetti()) {
    char json[128];
    snprintf(json, sizeof json,
             "{\"t\":%.1f,\"h\":%.0f,\"p\":%.1f,\"v\":%.2f}",
             t, h, p, vbat);
    mqtt.publish("casa/esterno/clima", json, true);
    mqtt.disconnect();
    ultimaT = t; ultimaH = h;
  }
  dormi();
}

void loop() {}
