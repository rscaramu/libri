// listato-09-04.ino — La stessa lettura sull'ESP32-S3 con MPU6050. La libreria restituisce m/s²; la divisione per 9,81 riporta a g, così i dati delle due schede sono confrontabili e lo stesso modello vale per entrambe.

#include <Adafruit_MPU6050.h>
Adafruit_MPU6050 mpu;

void setup() {
  Serial.begin(115200);
  while (!Serial);
  if (!mpu.begin()) {
    Serial.println("MPU6050 non trovato"); while (1);
  }
  mpu.setAccelerometerRange(MPU6050_RANGE_4_G);
  mpu.setFilterBandwidth(MPU6050_BAND_44_HZ);
}

void loop() {
  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);                 // in m/s^2
  Serial.print(a.acceleration.x / 9.81f, 3); Serial.print(',');
  Serial.print(a.acceleration.y / 9.81f, 3); Serial.print(',');
  Serial.println(a.acceleration.z / 9.81f, 3);
  delay(10);                                // 100 Hz
}
