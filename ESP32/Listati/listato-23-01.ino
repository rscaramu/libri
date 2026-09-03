// ESP32 — La guida completa alla famiglia · capitolo 23 (Display e camera)
// Listato 23.1 — LVGL su un display SPI con TFT_eSPI. Il buffer di 20 righe è un compromesso fra memoria e velocità; con la PSRAM si può usare un fotogramma intero.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

static lv_disp_draw_buf_t draw_buf;
static lv_color_t buf[320 * 20];      // 20 righe alla volta

void flush(lv_disp_drv_t *d, const lv_area_t *a, lv_color_t *p) {
  tft.pushImage(a->x1, a->y1, a->x2 - a->x1 + 1,
                a->y2 - a->y1 + 1, (uint16_t *)p);
  lv_disp_flush_ready(d);
}

void setup() {
  tft.begin();
  lv_init();
  lv_disp_draw_buf_init(&draw_buf, buf, NULL, 320 * 20);
  static lv_disp_drv_t drv;
  lv_disp_drv_init(&drv);
  drv.hor_res = 320; drv.ver_res = 240;
  drv.flush_cb = flush; drv.draw_buf = &draw_buf;
  lv_disp_drv_register(&drv);

  lv_obj_t *lbl = lv_label_create(lv_scr_act());
  lv_label_set_text(lbl, "Ciao");
  lv_obj_center(lbl);
}

void loop() {
  lv_timer_handler();
  delay(5);
}
