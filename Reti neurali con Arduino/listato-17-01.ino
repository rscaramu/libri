// listato-17-01.ino — Configurazione della camera. Scala di grigi a un byte per pixel, QVGA, due frame in PSRAM. La frequenza di clock a 20 MHz e la modalità "latest" evitano di elaborare frame vecchi.

#include "esp_camera.h"
#include "camera_pins.h"          // pin della XIAO ESP32S3 Sense

bool avviaCamera() {
  camera_config_t c = {};
  // ... assegnazione dei pin da camera_pins.h ...
  c.xclk_freq_hz  = 20000000;
  c.pixel_format  = PIXFORMAT_GRAYSCALE;    // 1 byte per pixel
  c.frame_size    = FRAMESIZE_QVGA;         // 320 x 240
  c.fb_count      = 2;                      // doppio buffer
  c.fb_location   = CAMERA_FB_IN_PSRAM;     // i frame in PSRAM
  c.grab_mode     = CAMERA_GRAB_LATEST;
  if (esp_camera_init(&c) != ESP_OK) return false;
  sensor_t* s = esp_camera_sensor_get();
  s->set_vflip(s, 1);                 // la XIAO ha la camera capovolta
  return true;
}
