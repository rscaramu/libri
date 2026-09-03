// ESP32 — La guida completa alla famiglia · capitolo 18 (PWM: LEDC e MCPWM)
// Listato 18.2 — LEDC in ESP-IDF. `ledc_set_duty` prepara il valore, `ledc_update_duty` lo applica: separati per poter cambiare più canali nello stesso istante.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

ledc_timer_config_t t = {
    .speed_mode      = LEDC_LOW_SPEED_MODE,
    .duty_resolution = LEDC_TIMER_10_BIT,
    .timer_num       = LEDC_TIMER_0,
    .freq_hz         = 20000,
    .clk_cfg         = LEDC_AUTO_CLK,
};
ledc_timer_config(&t);

ledc_channel_config_t c = {
    .gpio_num   = 4,
    .speed_mode = LEDC_LOW_SPEED_MODE,
    .channel    = LEDC_CHANNEL_0,
    .timer_sel  = LEDC_TIMER_0,
    .duty       = 0,
};
ledc_channel_config(&c);

ledc_set_duty(LEDC_LOW_SPEED_MODE, LEDC_CHANNEL_0, 512);
ledc_update_duty(LEDC_LOW_SPEED_MODE, LEDC_CHANNEL_0);
