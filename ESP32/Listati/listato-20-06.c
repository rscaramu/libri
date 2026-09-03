// ESP32 — La guida completa alla famiglia · capitolo 20 (I2C, SPI, UART, TWAI)
// Listato 20.6 — Invio e ricezione su CAN a 500 kbit/s. Il driver è lo stesso in Arduino, dove si include direttamente l'intestazione di ESP-IDF.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "driver/twai.h"

twai_general_config_t g = TWAI_GENERAL_CONFIG_DEFAULT(
    GPIO_NUM_21, GPIO_NUM_22, TWAI_MODE_NORMAL);
twai_timing_config_t t = TWAI_TIMING_CONFIG_500KBITS();
twai_filter_config_t f = TWAI_FILTER_CONFIG_ACCEPT_ALL();
twai_driver_install(&g, &t, &f);
twai_start();

twai_message_t msg = {
    .identifier = 0x123, .data_length_code = 2,
    .data = { 0x01, 0x02 },
};
twai_transmit(&msg, pdMS_TO_TICKS(100));

twai_message_t rx;
if (twai_receive(&rx, pdMS_TO_TICKS(1000)) == ESP_OK) {
    printf("id 0x%lx, %d byte\n", rx.identifier,
           rx.data_length_code);
}
