// ESP32 — La guida completa alla famiglia · capitolo 19 (Timer, RMT, PCNT)
// Listato 19.3 — Una striscia WS2812 con il componente `led_strip`, che sotto usa un canale RMT e un encoder dedicato.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

led_strip_handle_t strip;
led_strip_config_t sc = {
    .strip_gpio_num = 5, .max_leds = 30,
    .led_model = LED_MODEL_WS2812,
    .color_component_format = LED_STRIP_COLOR_COMPONENT_FMT_GRB,
};
led_strip_rmt_config_t rc = { .resolution_hz = 10000000 };
led_strip_new_rmt_device(&sc, &rc, &strip);

led_strip_set_pixel(strip, 0, 255, 0, 0);   // primo LED rosso
led_strip_refresh(strip);
