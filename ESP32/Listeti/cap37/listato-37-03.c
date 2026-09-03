// ESP32 — La guida completa alla famiglia · capitolo 37 (Sette progetti, uno per famiglia)
// Listato 37.3 — Il task LVGL e l'aggiornamento dell'interfaccia dallo stato ricevuto. LVGL non è thread-safe: ogni accesso da un task diverso passa dal mutex.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

static void task_lvgl(void *arg) {
    while (1) {
        if (xSemaphoreTake(mutex_lvgl, pdMS_TO_TICKS(10))) {
            lv_timer_handler();
            xSemaphoreGive(mutex_lvgl);
        }
        vTaskDelay(pdMS_TO_TICKS(5));
    }
}

static void su_stato(void *arg) {           // dal task di rete
    stato_t s;
    while (xQueueReceive(coda_stato, &s, portMAX_DELAY)) {
        if (xSemaphoreTake(mutex_lvgl, portMAX_DELAY)) {
            lv_label_set_text_fmt(lbl_temp, "%.1f °C", s.temp);
            lv_obj_set_state(sw_luce, LV_STATE_CHECKED, s.luce);
            xSemaphoreGive(mutex_lvgl);
        }
    }
}
