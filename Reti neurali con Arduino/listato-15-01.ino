// listato-15-01.ino — L'acquisizione è quella del capitolo 10, con quattro decimali perché le vibrazioni di una ventola sono di pochi millesimi di g. Le finestre sono di 2,56 s (256 campioni) per avere una risoluzione in frequenza di 0,4 Hz.

// Acquisizione per vibrazioni: finestra di 256 campioni, FFT
// La FFT la calcola Studio (o Keras); la scheda manda i campioni.
#include <Arduino_BMI270_BMM150.h>
void loop() {
  float x, y, z;
  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(x, y, z);
    Serial.print(x, 4); Serial.print(',');
    Serial.print(y, 4); Serial.print(',');
    Serial.println(z, 4);
  }
}
