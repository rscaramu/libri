// camera_xiao.h — pin della camera OV2640 sulla XIAO ESP32S3 Sense (da camera_pins.h del core esp32)
#pragma once
#include "esp_camera.h"
#define PWDN_GPIO_NUM  -1
#define RESET_GPIO_NUM -1
#define XCLK_GPIO_NUM  10
#define SIOD_GPIO_NUM  40
#define SIOC_GPIO_NUM  39
#define Y9_GPIO_NUM    48
#define Y8_GPIO_NUM    11
#define Y7_GPIO_NUM    12
#define Y6_GPIO_NUM    14
#define Y5_GPIO_NUM    16
#define Y4_GPIO_NUM    18
#define Y3_GPIO_NUM    17
#define Y2_GPIO_NUM    15
#define VSYNC_GPIO_NUM 38
#define HREF_GPIO_NUM  47
#define PCLK_GPIO_NUM  13

inline bool avviaCamera() {                        // listato 17.1
  camera_config_t c = {};
  c.ledc_channel = LEDC_CHANNEL_0; c.ledc_timer = LEDC_TIMER_0;
  c.pin_d0 = Y2_GPIO_NUM; c.pin_d1 = Y3_GPIO_NUM; c.pin_d2 = Y4_GPIO_NUM; c.pin_d3 = Y5_GPIO_NUM;
  c.pin_d4 = Y6_GPIO_NUM; c.pin_d5 = Y7_GPIO_NUM; c.pin_d6 = Y8_GPIO_NUM; c.pin_d7 = Y9_GPIO_NUM;
  c.pin_xclk = XCLK_GPIO_NUM; c.pin_pclk = PCLK_GPIO_NUM; c.pin_vsync = VSYNC_GPIO_NUM; c.pin_href = HREF_GPIO_NUM;
  c.pin_sccb_sda = SIOD_GPIO_NUM; c.pin_sccb_scl = SIOC_GPIO_NUM; c.pin_pwdn = PWDN_GPIO_NUM; c.pin_reset = RESET_GPIO_NUM;
  c.xclk_freq_hz = 20000000;
  c.pixel_format = PIXFORMAT_GRAYSCALE;
  c.frame_size = FRAMESIZE_QVGA;
  c.fb_count = 2;
  c.fb_location = CAMERA_FB_IN_PSRAM;
  c.grab_mode = CAMERA_GRAB_LATEST;
  if (esp_camera_init(&c) != ESP_OK) return false;
  sensor_t* s = esp_camera_sensor_get();
  if (s) s->set_vflip(s, 1);
  return true;
}

// ritaglio del quadrato centrale 240x240 e riduzione a 96x96 per media di blocchi 2,5x2,5 (approssimata a 5x5 su 480 virtuale)
inline void ritagliaERiduci(const uint8_t* src, int w, int h, uint8_t* dst) {
  int lato = h < w ? h : w, x0 = (w - lato) / 2, y0 = (h - lato) / 2;
  for (int y = 0; y < 96; y++)
    for (int x = 0; x < 96; x++) {
      int sy = y0 + y * lato / 96, sx = x0 + x * lato / 96, ey = y0 + (y + 1) * lato / 96, ex = x0 + (x + 1) * lato / 96;
      unsigned long s = 0; int n = 0;
      for (int yy = sy; yy < ey; yy++) for (int xx = sx; xx < ex; xx++) { s += src[yy * w + xx]; n++; }
      dst[y * 96 + x] = n ? s / n : 0;
    }
}
