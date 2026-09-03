// ESP32 — La guida completa alla famiglia · capitolo 37 (Sette progetti, uno per famiglia)
// Listato 37.6 — Il task di rilevamento sulla pipeline a bassa risoluzione, con un intervallo minimo di trenta secondi fra due eventi. Lo stream 720p gira su una pipeline separata e non è influenzato.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

static void task_rilevamento(void *arg)
{
    dl::Model modello("person_det.espdl");
    while (1) {
        frame_t *f = video_get_frame(pipeline_piccola, 500);
        if (!f) continue;
        auto ris = modello.run(f->buf, 224, 224);
        if (ris.persone > 0 && millis() - ultimo_evento > 30000) {
            ultimo_evento = millis();
            invia_evento("persona", f);
        }
        video_release_frame(pipeline_piccola, f);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}
