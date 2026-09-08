// listato-22-02.ino — Caricamento del modello dalla partizione sull'S3. Quattro controlli prima di restituire il puntatore: magic, versione delle feature, CRC. Se uno fallisce, il firmware prova l'altra partizione, e se fallisce anche quella, usa il modello compilato nello sketch come ultima risorsa.

#include "esp_partition.h"
const uint8_t* caricaModello(const char* nome) {
  const esp_partition_t* p = esp_partition_find_first(
      ESP_PARTITION_TYPE_DATA, (esp_partition_subtype_t)0x40, nome);
  if (!p) return nullptr;
  const void* base; esp_partition_mmap_handle_t h;
  if (esp_partition_mmap(p, 0, p->size, ESP_PARTITION_MMAP_DATA,
                         &base, &h) != ESP_OK) return nullptr;
  auto* hdr = (const IntestazioneModello*)base;
  const uint8_t* tflite = (const uint8_t*)base + sizeof *hdr;
  if (hdr->magic != 0x4D4C5431) return nullptr;
  if (hdr->versioneFeature != VERSIONE_FEATURE) return nullptr;
  if (crc32(tflite, hdr->lunghezza) != hdr->crc32) return nullptr;
  return tflite;                       // pronto per tflite::GetModel
}
