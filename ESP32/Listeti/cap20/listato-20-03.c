// ESP32 — La guida completa alla famiglia · capitolo 20 (I2C, SPI, UART, TWAI)
// Listato 20.3 — Bus e dispositivo SPI in ESP-IDF. `length` è in bit; per trasferimenti fino a 4 byte si possono usare i campi `tx_data` e `rx_data` senza buffer esterni.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

spi_bus_config_t bus = {
    .mosi_io_num = 23, .miso_io_num = 19, .sclk_io_num = 18,
    .quadwp_io_num = -1, .quadhd_io_num = -1,
    .max_transfer_sz = 4096,
};
spi_bus_initialize(SPI2_HOST, &bus, SPI_DMA_CH_AUTO);

spi_device_interface_config_t dev = {
    .clock_speed_hz = 10 * 1000 * 1000,
    .mode = 0, .spics_io_num = 5, .queue_size = 4,
};
spi_device_handle_t h;
spi_bus_add_device(SPI2_HOST, &dev, &h);

uint8_t tx[2] = { 0x80 | 0x0F, 0x00 }, rx[2];
spi_transaction_t t = {
    .length = 16, .tx_buffer = tx, .rx_buffer = rx,
};
spi_device_transmit(h, &t);       // rx[1] contiene il registro
