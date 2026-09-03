// ESP32 — La guida completa alla famiglia · capitolo 20 (I2C, SPI, UART, TWAI)
// Listato 20.1 — Lettura del registro ID di un BME280 in ESP-IDF. Ogni dispositivo sul bus è un oggetto con il proprio indirizzo e la propria velocità.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

i2c_master_bus_handle_t bus;
i2c_master_bus_config_t bc = {
    .i2c_port = I2C_NUM_0, .sda_io_num = 21, .scl_io_num = 22,
    .clk_source = I2C_CLK_SRC_DEFAULT,
    .glitch_ignore_cnt = 7,
    .flags.enable_internal_pullup = false,
};
i2c_new_master_bus(&bc, &bus);

i2c_master_dev_handle_t dev;
i2c_device_config_t dc = {
    .dev_addr_length = I2C_ADDR_BIT_LEN_7,
    .device_address = 0x76, .scl_speed_hz = 400000,
};
i2c_master_bus_add_device(bus, &dc, &dev);

uint8_t reg = 0xD0, id;
i2c_master_transmit_receive(dev, &reg, 1, &id, 1, 100);
