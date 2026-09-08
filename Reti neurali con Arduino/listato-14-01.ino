// listato-14-01.ino — Acquisizione a sei assi. Il giroscopio è diviso per 500 per portarlo nello stesso intervallo dell'accelerometro; la rete lavora meglio con ingressi sulla stessa scala, e la divisione va ripetuta identica sulla scheda.

#include <Arduino_BMI270_BMM150.h>
const int PULSANTE = 2;           // premuto durante la caduta

void setup() {
  Serial.begin(115200);
  while (!Serial);
  if (!IMU.begin()) while (1);
  pinMode(PULSANTE, INPUT_PULLUP);
}

void loop() {
  float ax, ay, az, gx, gy, gz;
  if (IMU.accelerationAvailable() && IMU.gyroscopeAvailable()) {
    IMU.readAcceleration(ax, ay, az);           // g
    IMU.readGyroscope(gx, gy, gz);              // gradi/s
    Serial.print(ax, 3); Serial.print(',');
    Serial.print(ay, 3); Serial.print(',');
    Serial.print(az, 3); Serial.print(',');
    Serial.print(gx / 500.0f, 3); Serial.print(',');   // ±500 -> ±1
    Serial.print(gy / 500.0f, 3); Serial.print(',');
    Serial.println(gz / 500.0f, 3);
  }
}
