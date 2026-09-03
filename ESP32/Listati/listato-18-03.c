// ESP32 — La guida completa alla famiglia · capitolo 18 (PWM: LEDC e MCPWM)
// Listato 18.3 — Il nucleo di una configurazione MCPWM con tempo morto di 2 microsecondi fra le due uscite. L'esempio completo è nel repository del libro, sotto `cap18/ponte_h`.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

mcpwm_timer_handle_t tmr;
mcpwm_timer_config_t tc = {
    .group_id      = 0,
    .clk_src       = MCPWM_TIMER_CLK_SRC_DEFAULT,
    .resolution_hz = 10000000,           // 10 MHz → 0,1 us
    .period_ticks  = 500,                // 20 kHz
    .count_mode    = MCPWM_TIMER_COUNT_MODE_UP,
};
mcpwm_new_timer(&tc, &tmr);
// ... operatore, comparatore, due generatori ...
mcpwm_dead_time_config_t dt = {
    .posedge_delay_ticks = 20,           // 2 us
};
mcpwm_generator_set_dead_time(gen_a, gen_a, &dt);
dt = (mcpwm_dead_time_config_t){ .negedge_delay_ticks = 20,
                                 .flags.invert_output = true };
mcpwm_generator_set_dead_time(gen_a, gen_b, &dt);
