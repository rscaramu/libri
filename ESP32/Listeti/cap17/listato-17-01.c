// ESP32 — La guida completa alla famiglia · capitolo 17 (ADC, DAC, touch)
// Listato 17.1 — Lettura calibrata in ESP-IDF. Lo schema *curve fitting* è disponibile sui chip recenti; sull'ESP32 classico si usa *line fitting*.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "esp_adc/adc_oneshot.h"
#include "esp_adc/adc_cali.h"
#include "esp_adc/adc_cali_scheme.h"

adc_oneshot_unit_handle_t adc;
adc_oneshot_unit_init_cfg_t ucfg = { .unit_id = ADC_UNIT_1 };
adc_oneshot_new_unit(&ucfg, &adc);

adc_oneshot_chan_cfg_t ccfg = {
    .atten    = ADC_ATTEN_DB_12,
    .bitwidth = ADC_BITWIDTH_DEFAULT,
};
adc_oneshot_config_channel(adc, ADC_CHANNEL_6, &ccfg);

adc_cali_handle_t cali;
adc_cali_curve_fitting_config_t kcfg = {
    .unit_id = ADC_UNIT_1, .atten = ADC_ATTEN_DB_12,
    .bitwidth = ADC_BITWIDTH_DEFAULT,
};
adc_cali_create_scheme_curve_fitting(&kcfg, &cali);

int raw, mv;
adc_oneshot_read(adc, ADC_CHANNEL_6, &raw);
adc_cali_raw_to_voltage(cali, raw, &mv);
