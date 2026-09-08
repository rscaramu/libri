// listato-14-05.ino — L'allarme via Wi-Fi sull'S3: una richiesta HTTP a un webhook. Il Wi-Fi acceso costa 80–100 mA e per un dispositivo a batteria va acceso solo nel momento dell'allarme, come il capitolo 21 mostra.

#include <WiFi.h>
#include <HTTPClient.h>

void segnalaCaduta() {
  digitalWrite(LED_BUILTIN, LOW);
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://192.168.1.10:8123/api/webhook/caduta");
    http.POST("");                          // Home Assistant, o altro
    http.end();
  }
  delay(2000);
  digitalWrite(LED_BUILTIN, HIGH);
}
