// listato 10.2 — acquisizione a 100 Hz esatti con micros(), ESP32-S3 + MPU6050
#include <Adafruit_MPU6050.h>
#include <Wire.h>
Adafruit_MPU6050 mpu;
unsigned long prossimo = 0;
void setup() {
  Serial.begin(115200);
  if (!mpu.begin()) while (1);
  mpu.setAccelerometerRange(MPU6050_RANGE_4_G);
  mpu.setFilterBandwidth(MPU6050_BAND_44_HZ);
  prossimo = micros();
}
void loop() {
  if ((long)(micros() - prossimo) < 0) return;
  prossimo += 10000;
  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);
  Serial.print(a.acceleration.x / 9.81f, 3); Serial.print(',');
  Serial.print(a.acceleration.y / 9.81f, 3); Serial.print(',');
  Serial.println(a.acceleration.z / 9.81f, 3);
}
