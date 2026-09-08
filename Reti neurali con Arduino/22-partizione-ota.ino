// capitolo 22 — modello in partizione A/B, caricamento con mmap e verifica (22.2), aggiornamento via HTTP (22.3)
#include <WiFi.h>
#include <HTTPClient.h>
#include <Preferences.h>
#include "esp_partition.h"
#include "esp_crc.h"
#include <Chirale_TensorFlowLite.h>
#include <tensorflow/lite/micro/micro_mutable_op_resolver.h>
#include <tensorflow/lite/micro/micro_interpreter.h>
#include <tensorflow/lite/schema/schema_generated.h>
#include "gesti_modello.h"                            // modello di riserva compilato nello sketch

const uint16_t VERSIONE_FEATURE = 1;
struct IntestazioneModello { uint32_t magic; uint16_t versione; uint16_t versioneFeature; uint32_t lunghezza; uint32_t crc32; };
Preferences prefs;

const uint8_t* caricaModello(const char* nome) {
  const esp_partition_t* p = esp_partition_find_first(ESP_PARTITION_TYPE_DATA, (esp_partition_subtype_t)0x40, nome);
  if (!p) return nullptr;
  const void* base; esp_partition_mmap_handle_t h;
  if (esp_partition_mmap(p, 0, p->size, ESP_PARTITION_MMAP_DATA, &base, &h) != ESP_OK) return nullptr;
  auto* hdr = (const IntestazioneModello*)base;
  const uint8_t* tflite = (const uint8_t*)base + sizeof *hdr;
  if (hdr->magic != 0x4D4C5431) return nullptr;
  if (hdr->versioneFeature != VERSIONE_FEATURE) return nullptr;
  if (esp_crc32_le(0, tflite, hdr->lunghezza) != hdr->crc32) return nullptr;
  return tflite;
}
const esp_partition_t* partizioneLibera() {
  String attiva = prefs.getString("attiva", "modelloA");
  return esp_partition_find_first(ESP_PARTITION_TYPE_DATA, (esp_partition_subtype_t)0x40, attiva == "modelloA" ? "modelloB" : "modelloA");
}
bool aggiornaModello(const char* url) {
  HTTPClient http; http.begin(url);
  if (http.GET() != 200) return false;
  const esp_partition_t* dest = partizioneLibera();
  esp_partition_erase_range(dest, 0, dest->size);
  WiFiClient* s = http.getStreamPtr();
  uint8_t buf[4096]; size_t off = 0; int n;
  while ((n = s->readBytes(buf, sizeof buf)) > 0) { if (esp_partition_write(dest, off, buf, n) != ESP_OK) return false; off += n; }
  http.end();
  if (!caricaModello(dest->label)) return false;
  prefs.putString("attiva", dest->label);
  ESP.restart();
  return true;
}
void setup() {
  Serial.begin(115200);
  prefs.begin("modello", false);
  String attiva = prefs.getString("attiva", "modelloA");
  const uint8_t* modello = caricaModello(attiva.c_str());
  if (!modello) modello = caricaModello(attiva == "modelloA" ? "modelloB" : "modelloA");
  if (!modello) { modello = gesti_tflite; Serial.println("uso il modello di riserva compilato"); }
  const tflite::Model* m = tflite::GetModel(modello);
  static tflite::MicroMutableOpResolver<2> r; r.AddFullyConnected(); r.AddSoftmax();
  static uint8_t arena[4 * 1024] __attribute__((aligned(16)));
  static tflite::MicroInterpreter it(m, r, arena, sizeof arena);
  Serial.println(it.AllocateTensors() == kTfLiteOk ? "modello pronto" : "arena");
}
void loop() {
  if (Serial.available() && Serial.read() == 'u') aggiornaModello("http://192.168.1.10/modelli/gesti.bin");
}
