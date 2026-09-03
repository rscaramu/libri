// ESP32 — La guida completa alla famiglia · capitolo 19 (Timer, RMT, PCNT)
// Listato 19.4 — Un encoder letto con PCNT: un canale conta i fronti di A e il livello di B decide il segno. Il filtro da 1 µs elimina i rimbalzi dei contatti.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "driver/pulse_cnt.h"

pcnt_unit_handle_t unit;
pcnt_unit_config_t uc = { .high_limit = 1000, .low_limit = -1000 };
pcnt_new_unit(&uc, &unit);

pcnt_glitch_filter_config_t f = { .max_glitch_ns = 1000 };
pcnt_unit_set_glitch_filter(unit, &f);

pcnt_chan_config_t ca = { .edge_gpio_num = 4, .level_gpio_num = 5 };
pcnt_channel_handle_t cha;
pcnt_new_channel(unit, &ca, &cha);
pcnt_channel_set_edge_action(cha,
    PCNT_CHANNEL_EDGE_ACTION_DECREASE,
    PCNT_CHANNEL_EDGE_ACTION_INCREASE);
pcnt_channel_set_level_action(cha,
    PCNT_CHANNEL_LEVEL_ACTION_KEEP,
    PCNT_CHANNEL_LEVEL_ACTION_INVERSE);

pcnt_unit_enable(unit);
pcnt_unit_clear_count(unit);
pcnt_unit_start(unit);

int conteggio;
pcnt_unit_get_count(unit, &conteggio);
