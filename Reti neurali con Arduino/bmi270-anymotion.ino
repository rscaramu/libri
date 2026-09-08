// strumenti/bmi270-anymotion.ino — capitolo 21: any-motion del BMI270 via registri, con interrupt su INT1.
// La libreria Arduino_BMI270_BMM150 1.2.4 non espone l'any-motion né la frequenza di campionamento.
// Dopo IMU.begin() (che carica il firmware di configurazione del sensore) si scrivono i registri:
//   FEATURES (pagina 0) offset ANY_MOTION: durata, soglia e abilitazione degli assi
//   INT1_IO_CTRL (0x53): INT1 come uscita push-pull attiva alta
//   INT1_MAP_FEAT (0x56): mappa any-motion su INT1
// I valori sono quelli del datasheet BMI270 (Bosch, rev. 2.x). Verificare la tabella delle feature
// nella versione del firmware caricata dalla libreria: l'offset di ANY_MOTION può cambiare.
#include <Arduino_BMI270_BMM150.h>
#include <Wire.h>
const uint8_t BMI = 0x68;
void scrivi(uint8_t reg, uint8_t val) { Wire1.beginTransmission(BMI); Wire1.write(reg); Wire1.write(val); Wire1.endTransmission(); }
uint8_t leggi(uint8_t reg) { Wire1.beginTransmission(BMI); Wire1.write(reg); Wire1.endTransmission(false); Wire1.requestFrom(BMI, (uint8_t)1); return Wire1.read(); }

void abilitaAnyMotion(uint16_t durata = 5, uint16_t soglia = 0xAA) {   // durata in unità di 20 ms; soglia ~ 83 mg
  scrivi(0x2F, 0x00);                          // FEAT_PAGE = 0
  // parametri any-motion nell'area FEATURES (0x30..): offset 0x3C nella configurazione standard
  scrivi(0x3C, durata & 0xFF); scrivi(0x3D, (durata >> 8) | 0xE0);    // durata + assi x,y,z abilitati
  scrivi(0x3E, soglia & 0xFF); scrivi(0x3F, (soglia >> 8) | 0x08);     // soglia + out_conf su INT1
  scrivi(0x53, 0x0A);                          // INT1: output enable, push-pull, attivo alto
  scrivi(0x56, 0x40);                          // INT1_MAP_FEAT: any-motion
}
void setup() {
  Serial.begin(115200);
  if (!IMU.begin()) while (1);
  abilitaAnyMotion();
  pinMode(2, INPUT);                           // INT1 del BMI270 sulla Nano Rev2 è collegato a... vedi schema: usare un filo verso D2
  Serial.print("INT1_MAP_FEAT = 0x"); Serial.println(leggi(0x56), HEX);
}
void loop() {
  Serial.println(digitalRead(2) ? "movimento" : "fermo");
  delay(200);
}
