# Progetto 37.6

Il task di rilevamento sulla pipeline a bassa risoluzione, con un intervallo minimo di trenta secondi fra due eventi. Lo stream 720p gira su una pipeline separata e non è influenzato.

Questo progetto è **strutturale**: il `main.c` mostra come è organizzato il programma, non compila da solo.

Esempi di riferimento: `esp-idf/examples/peripherals/camera` (P4), `esp-hosted` (P4 + C6), `esp-dl/examples/human_face_detect` adattato al modello persone, `esp_h264` per la codifica.
