# Progetto 37.4

La struttura di un dispositivo `esp-matter`: un nodo, due endpoint, una callback per gli attributi che il controller scrive. La rete Thread e il commissioning sono gestiti dal framework.

Questo progetto è **strutturale**: il `main.c` mostra come è organizzato il programma, non compila da solo.

Esempi di riferimento: `esp-matter/examples/light`, `esp-matter/examples/sensors`. Selezionare `idf.py set-target esp32c6` e la rete Thread in menuconfig.
