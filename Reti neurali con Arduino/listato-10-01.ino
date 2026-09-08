// listato-10-01.ino — Sketch di acquisizione per il data forwarder. È il listato 9.1 senza il messaggio iniziale: la seriale porta solo numeri.

#include <Arduino_BMI270_BMM150.h>

void setup() {
  Serial.begin(115200);
  while (!Serial);
  if (!IMU.begin()) while (1);
}

void loop() {
  float x, y, z;
  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(x, y, z);
    Serial.print(x, 3); Serial.print(',');
    Serial.print(y, 3); Serial.print(',');
    Serial.println(z, 3);
  }
}
