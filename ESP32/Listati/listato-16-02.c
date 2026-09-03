// ESP32 — La guida completa alla famiglia · capitolo 16 (GPIO)
// Listato 16.2 — Lo stesso interrupt in ESP-IDF. La ISR non fa lavoro: mette il numero del pin in una coda, e un task lo gestisce con calma.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

static void IRAM_ATTR gpio_isr(void *arg) {
    uint32_t pin = (uint32_t)arg;
    BaseType_t woke = pdFALSE;
    xQueueSendFromISR(coda_eventi, &pin, &woke);
    if (woke) portYIELD_FROM_ISR();
}

gpio_config_t io = {
    .pin_bit_mask = BIT64(PIN_PULSANTE),
    .mode         = GPIO_MODE_INPUT,
    .pull_up_en   = GPIO_PULLUP_ENABLE,
    .intr_type    = GPIO_INTR_NEGEDGE,
};
gpio_config(&io);
gpio_install_isr_service(0);
gpio_isr_handler_add(PIN_PULSANTE, gpio_isr,
                     (void *)PIN_PULSANTE);
