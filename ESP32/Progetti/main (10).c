// Progetto 37.6 — Il task di rilevamento sulla pipeline a bassa risoluzione, con un intervallo minimo di trenta secondi fra due eventi. Lo stream 720p gira su una pipeline separata e non è influenzato.
// Listato strutturale: mostra l'organizzazione del programma. Va letto e completato
// accanto agli esempi del framework indicati nel README di questa cartella.

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
