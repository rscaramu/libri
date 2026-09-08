// listato-09-01.ino — Lettura dell'accelerometro sulla Nano 33 BLE Sense Rev2. I valori sono in g; con la scheda ferma sul tavolo si legge circa 0, 0, 1.

#include <Arduino_BMI270_BMM150.h>

void setup() {
  Serial.begin(115200);
  while (!Serial);
  if (!IMU.begin()) { Serial.println("IMU non trovato"); while (1); }
  Serial.print("Frequenza accelerometro: ");
  Serial.println(IMU.accelerationSampleRate());   // circa 100 Hz
}

void loop() {
  float x, y, z;
  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(x, y, z);                // in g
    Serial.print(x, 3); Serial.print(',');
    Serial.print(y, 3); Serial.print(',');
    Serial.println(z, 3);
  }
}
