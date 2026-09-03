# Progetto 37.3

Il task LVGL e l'aggiornamento dell'interfaccia dallo stato ricevuto. LVGL non è thread-safe: ogni accesso da un task diverso passa dal mutex.

Questo progetto è **strutturale**: il `main.c` mostra come è organizzato il programma, non compila da solo.

Esempi di riferimento: `esp-idf/examples/peripherals/lcd/rgb_panel`, `lvgl/lvgl_port`, `esp-sr/examples/en_speech_commands_recognition`.
