// listato-10-02.ino — Sull'ESP32-S3 il loop è temporizzato a micros(), perché l'MPU6050 non segnala quando ha un campione nuovo. Il setup è quello del listato 9.4.

unsigned long prossimo = 0;
void loop() {
  if (micros() < prossimo) return;
  prossimo += 10000;                     // 100 Hz esatti
  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);
  Serial.print(a.acceleration.x / 9.81f, 3); Serial.print(',');
  Serial.print(a.acceleration.y / 9.81f, 3); Serial.print(',');
  Serial.println(a.acceleration.z / 9.81f, 3);
}
