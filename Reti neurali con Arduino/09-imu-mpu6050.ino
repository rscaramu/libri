// listato 9.4 — MPU6050 sull'ESP32-S3 (XIAO: SDA=D4, SCL=D5)
#include <Adafruit_MPU6050.h>
#include <Wire.h>
Adafruit_MPU6050 mpu;
void setup() {
  Serial.begin(115200);
  while (!Serial);
  if (!mpu.begin()) { Serial.println("MPU6050 non trovato"); while (1); }
  mpu.setAccelerometerRange(MPU6050_RANGE_4_G);
  mpu.setFilterBandwidth(MPU6050_BAND_44_HZ);
}
void loop() {
  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);
  Serial.print(a.acceleration.x / 9.81f, 3); Serial.print(',');
  Serial.print(a.acceleration.y / 9.81f, 3); Serial.print(',');
  Serial.println(a.acceleration.z / 9.81f, 3);
  delay(10);
}
