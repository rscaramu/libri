// ESP32 — La guida completa alla famiglia · capitolo 20 (I2C, SPI, UART, TWAI)
// Listato 20.5 — Lettura per righe con la rilevazione di pattern. L'evento arriva quando il terminatore è nel buffer; `uart_pattern_pop_pos` dice dove.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "driver/uart.h"

QueueHandle_t eventi;
uart_config_t c = {
    .baud_rate = 9600, .data_bits = UART_DATA_8_BITS,
    .parity = UART_PARITY_DISABLE, .stop_bits = UART_STOP_BITS_1,
    .flow_ctrl = UART_HW_FLOWCTRL_DISABLE,
    .source_clk = UART_SCLK_DEFAULT,
};
uart_driver_install(UART_NUM_1, 2048, 0, 20, &eventi, 0);
uart_param_config(UART_NUM_1, &c);
uart_set_pin(UART_NUM_1, 17, 16, -1, -1);   // TX, RX, RTS, CTS
uart_enable_pattern_det_baud_intr(UART_NUM_1, '\n', 1, 9, 0, 0);
uart_pattern_queue_reset(UART_NUM_1, 20);

uart_event_t ev;
char riga[128];
for (;;) {
    if (xQueueReceive(eventi, &ev, portMAX_DELAY) &&
        ev.type == UART_PATTERN_DET) {
        int pos = uart_pattern_pop_pos(UART_NUM_1);
        int n = uart_read_bytes(UART_NUM_1, riga, pos + 1, 0);
        riga[n] = 0;
        // riga contiene una frase completa
    }
}
