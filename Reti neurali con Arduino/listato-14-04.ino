// listato-14-04.ino — Allarme BLE con ArduinoBLE. La scheda espone un servizio con una caratteristica da un byte; un telefono con un'app BLE generica (nRF Connect, LightBlue) si connette, si iscrive alle notifiche e riceve 1 quando c'è una caduta. BLE.poll va chiamata a ogni giro del loop.

#include <ArduinoBLE.h>

BLEService servizio("19B10000-E8F2-537E-4F6C-D104768A1214");
BLEByteCharacteristic evento("19B10001-E8F2-537E-4F6C-D104768A1214",
                             BLERead | BLENotify);

void setupBLE() {
  if (!BLE.begin()) while (1);
  BLE.setLocalName("Cadute");
  BLE.setAdvertisedService(servizio);
  servizio.addCharacteristic(evento);
  BLE.addService(servizio);
  evento.writeValue(0);
  BLE.advertise();
}

void segnalaCaduta() {
  digitalWrite(LEDR, LOW);                 // LED RGB attivo basso
  evento.writeValue(1);                    // notifica ai connessi
  delay(2000);
  evento.writeValue(0);
  digitalWrite(LEDR, HIGH);
}

// nel loop, ogni iterazione:
//   BLE.poll();
//   if (stabilizza(classe, p) == CADUTA) segnalaCaduta();
