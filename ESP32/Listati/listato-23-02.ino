// ESP32 — La guida completa alla famiglia · capitolo 23 (Display e camera)
// Listato 23.2 — Inizializzazione della camera con i pin dell'ESP32-CAM e cattura di un fotogramma JPEG. `fb_count = 2` con `CAMERA_GRAB_LATEST` tiene sempre pronto l'ultimo fotogramma.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "esp_camera.h"

camera_config_t cfg = {
  .pin_pwdn = 32, .pin_reset = -1, .pin_xclk = 0,
  .pin_sccb_sda = 26, .pin_sccb_scl = 27,
  .pin_d7 = 35, .pin_d6 = 34, .pin_d5 = 39, .pin_d4 = 36,
  .pin_d3 = 21, .pin_d2 = 19, .pin_d1 = 18, .pin_d0 = 5,
  .pin_vsync = 25, .pin_href = 23, .pin_pclk = 22,
  .xclk_freq_hz = 20000000,
  .ledc_timer = LEDC_TIMER_0, .ledc_channel = LEDC_CHANNEL_0,
  .pixel_format = PIXFORMAT_JPEG,
  .frame_size = FRAMESIZE_VGA,
  .jpeg_quality = 12,
  .fb_count = 2,
  .fb_location = CAMERA_FB_IN_PSRAM,
  .grab_mode = CAMERA_GRAB_LATEST,
};

void setup() {
  Serial.begin(115200);
  if (esp_camera_init(&cfg) != ESP_OK) {
    Serial.println("camera non inizializzata");
    return;
  }
  camera_fb_t *fb = esp_camera_fb_get();
  Serial.printf("JPEG %u x %u, %u byte\n",
                fb->width, fb->height, fb->len);
  esp_camera_fb_return(fb);      // sempre, o i buffer finiscono
}
