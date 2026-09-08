// listato-21-01.ino — Sonno profondo del nRF52840. La scheda consuma 40–60 µA e riparte da capo quando il pin va alto. Il codice usa le funzioni del chip, perché il core Mbed non espone un'API di sonno; l'header `hal/nrf_gpio.h` è quello del core.

// Nano 33 BLE: sonno profondo con risveglio dal pin dell'IMU
#include <nrf.h>
#include <hal/nrf_gpio.h>
#include <Wire.h>
void spegniIMU() {            // PWR_CTRL = 0: il BMI270 in sospensione
  Wire1.beginTransmission(0x68); Wire1.write(0x7D);
  Wire1.write(0x00); Wire1.endTransmission();
}
void dormiProfondo(int pinSveglia) {
  spegniIMU();
  nrf_gpio_cfg_sense_input(digitalPinToPinName(pinSveglia),
                           NRF_GPIO_PIN_PULLDOWN,
                           NRF_GPIO_PIN_SENSE_HIGH);
  NRF_POWER->SYSTEMOFF = 1;   // esce con un reset dal pin
}
