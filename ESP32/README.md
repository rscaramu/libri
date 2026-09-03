# ESP32 — La guida completa alla famiglia · codice

Codice del libro di **Roberto Scaramuzzino**. Licenza MIT.

## Struttura

- `listati/capNN/` — ogni listato del libro, nel file `listato-NN-MM.<ext>`, con la didascalia in testa. I frammenti senza numero (comandi, output, esempi di due righe) sono in `frammento-NN-MM`.
- `progetti/` — i sette progetti del capitolo 37. Quelli Arduino sono cartelle PlatformIO (`platformio.ini` + `src/`); quelli ESP-IDF hanno `CMakeLists.txt` e `main/`.

## Come usare i listati

I listati riproducono esattamente il libro: il nucleo dell'esempio, non un programma completo. Le funzioni richiamate e non definite sono indicate nella didascalia o nel capitolo. Per compilarli si copia il file in un progetto PlatformIO (`.ino` → `src/main.cpp`) o ESP-IDF (`.c` → `main/main.c`) con le librerie indicate.

Nessuna riga supera i 72 caratteri, per coerenza con l'impaginazione del libro.

## Progetti

| Cartella | Chip | Ambiente | Stato |
|---|---|---|---|
| `01-sensore-batteria-c3` | ESP32-C3 | PlatformIO / Arduino | nucleo + funzioni di supporto da completare (listati 30.3, 26.1) |
| `02-nodo-domotico-mqtt-esp32` | ESP32 | PlatformIO / Arduino | nucleo + funzioni di supporto (listati 24.2, 26.1) |
| `03-pannello-lvgl-s3` | ESP32-S3 | ESP-IDF | strutturale |
| `04-matter-thread-c6` | ESP32-C6 | ESP-IDF + esp-matter | strutturale |
| `05-sensore-zigbee-h2` | ESP32-H2 | PlatformIO / Arduino | nucleo completo |
| `06-videocitofono-p4` | ESP32-P4 + C6 | ESP-IDF | strutturale |
| `07-datalogger-epaper-s3` | ESP32-S3 | PlatformIO / Arduino | nucleo + funzioni di supporto |

«Strutturale» significa che il sorgente mostra l'organizzazione del programma e va letto accanto agli esempi del framework indicati nel `README` della cartella. Tutti i progetti sono da verificare su hardware prima dell'uso: i valori di consumo nel libro sono stime.

## Versioni di riferimento

- Arduino-ESP32 core 3.x (piattaforma PlatformIO `pioarduino`)
- ESP-IDF 5.5
- MicroPython 1.26

## Indice dei listati

| Cap. | Listato | File | Contenuto |
|---|---|---|---|
| 1 | 1.— | `listati/cap01/frammento-01-01.txt` | frammento (Come leggere una sigla completa) |
| 6 | 6.— | `listati/cap06/frammento-06-01.txt` | frammento (Installare l'ambiente) |
| 6 | 6.— | `listati/cap06/frammento-06-02.txt` | frammento (Il primo caricamento) |
| 6 | 6.1 | `listati/cap06/listato-06-01.ino` | Il lampeggio. Sull'ESP32 classico il LED di bordo è sul GPIO2; su molte schede S3 e C3 è su un altro pin, riportato sulla serigrafia o nella documentazione. |
| 6 | 6.2 | `listati/cap06/listato-06-02.ino` | Il lampeggio con messaggi sulla seriale. `Serial.printf()` esiste sull'ESP32 e non su molti altri Arduino: è comodissimo e lo useremo sempre. |
| 7 | 7.— | `listati/cap07/frammento-07-01.ino` | frammento (Le rotture di compatibilità fra 2.x e 3.x) |
| 7 | 7.— | `listati/cap07/frammento-07-02.ino` | frammento (Le rotture di compatibilità fra 2.x e 3.x) |
| 7 | 7.1 | `listati/cap07/listato-07-01.ino` | Una funzione ESP-IDF chiamata da uno sketch Arduino. L'intestazione `esp_system.h` è nella cartella del core. |
| 8 | 8.— | `listati/cap08/frammento-08-01.sh` | frammento (Installazione) |
| 8 | 8.— | `listati/cap08/frammento-08-02.txt` | frammento (Struttura di un progetto) |
| 8 | 8.— | `listati/cap08/frammento-08-03.cmake` | frammento (Il sistema di build e i componenti) |
| 8 | 8.— | `listati/cap08/frammento-08-04.cmake` | frammento (Il sistema di build e i componenti) |
| 8 | 8.— | `listati/cap08/frammento-08-05.yaml` | frammento (Il registro dei componenti) |
| 8 | 8.— | `listati/cap08/frammento-08-06.sh` | frammento (menuconfig) |
| 8 | 8.— | `listati/cap08/frammento-08-07.sh` | frammento (idf.py) |
| 8 | 8.— | `listati/cap08/frammento-08-08.txt` | frammento (idf.py) |
| 8 | 8.1 | `listati/cap08/listato-08-01.c` | Il lampeggio in ESP-IDF. Rispetto al listato 6.1 le funzioni sono più esplicite e il ritardo è quello di FreeRTOS. |
| 9 | 9.— | `listati/cap09/frammento-09-01.ini` | frammento (Ambienti multipli) |
| 9 | 9.1 | `listati/cap09/listato-09-01.ini` | Un `platformio.ini` per un progetto Arduino su ESP32-S3 con PSRAM. La riga `platform` punta alla piattaforma mantenuta dalla comunità, per le ragioni spiegate sotto. |
| 10 | 10.— | `listati/cap10/frammento-10-01.sh` | frammento (MicroPython) |
| 10 | 10.— | `listati/cap10/frammento-10-02.sh` | frammento (MicroPython) |
| 10 | 10.— | `listati/cap10/frammento-10-03.sh` | frammento (MicroPython) |
| 10 | 10.1 | `listati/cap10/listato-10-01.py` | Il lampeggio in MicroPython. Si copia sulla scheda con `mpremote cp main.py :` e parte da solo al reset. |
| 11 | 11.— | `listati/cap11/frammento-11-01.sh` | frammento (esptool) |
| 11 | 11.— | `listati/cap11/frammento-11-02.sh` | frammento (esptool) |
| 11 | 11.— | `listati/cap11/frammento-11-03.sh` | frammento (esptool) |
| 11 | 11.— | `listati/cap11/frammento-11-04.sh` | frammento (esptool) |
| 11 | 11.— | `listati/cap11/frammento-11-05.sh` | frammento (esptool) |
| 11 | 11.— | `listati/cap11/frammento-11-06.sh` | frammento (Debug JTAG) |
| 11 | 11.1 | `listati/cap11/listato-11-01.csv` | Una tabella per una flash da 8 MB con due partizioni applicazione da 3 MB per l'OTA e un filesystem da circa 2 MB. |
| 12 | 12.— | `listati/cap12/frammento-12-01.ino` | frammento (Frammentazione dell'heap) |
| 12 | 12.1 | `listati/cap12/listato-12-01.c` | I tre attributi di posizionamento. Senza `DRAM_ATTR`, una costante finisce in flash e una ISR che la legge durante una scrittura in flash va in crash. |
| 12 | 12.2 | `listati/cap12/listato-12-02.txt` | Allocazione per capacità. In Arduino esistono le scorciatoie `ps_malloc()` per la PSRAM e `psramFound()` per verificare che ci sia. |
| 13 | 13.— | `listati/cap13/frammento-13-01.ino` | frammento (Cosa gira davvero quando scrivi loop()) |
| 13 | 13.— | `listati/cap13/frammento-13-02.c` | frammento (Code, semafori, mutex, event group) |
| 13 | 13.— | `listati/cap13/frammento-13-03.c` | frammento (Code, semafori, mutex, event group) |
| 13 | 13.— | `listati/cap13/frammento-13-04.c` | frammento (Code, semafori, mutex, event group) |
| 13 | 13.1 | `listati/cap13/listato-13-01.ino` | Creazione di un task assegnato al core 0. `xTaskCreate` senza `PinnedToCore` lascia scegliere allo scheduler. |
| 13 | 13.2 | `listati/cap13/listato-13-02.c` | Una notifica usata come semaforo binario. Il primo parametro di `ulTaskNotifyTake` azzera il contatore alla ricezione. |
| 13 | 13.3 | `listati/cap13/listato-13-03.c` | Una sezione critica intorno a un contatore. Le due varianti, con e senza `_ISR`, servono rispettivamente dentro e fuori le routine di interrupt. |
| 14 | 14.— | `listati/cap14/frammento-14-01.txt` | frammento (La sequenza dall'accensione ad app_main()) |
| 14 | 14.— | `listati/cap14/frammento-14-02.sh` | frammento (eFuse) |
| 15 | 15.— | `listati/cap15/frammento-15-01.txt` | frammento (Sorgenti di clock) |
| 15 | 15.— | `listati/cap15/frammento-15-02.c` | frammento (I tre watchdog) |
| 15 | 15.— | `listati/cap15/frammento-15-03.c` | frammento (Il sistema di log) |
| 15 | 15.— | `listati/cap15/frammento-15-04.c` | frammento (Il sistema di log) |
| 15 | 15.— | `listati/cap15/frammento-15-05.txt` | frammento (Leggere un panic) |
| 15 | 15.— | `listati/cap15/frammento-15-06.txt` | frammento (Leggere un panic) |
| 15 | 15.1 | `listati/cap15/listato-15-01.ino` | Le cause di reset leggibili con `esp_reset_reason()`. Stamparla all'avvio, e magari salvarla in NVS, è il modo più economico di diagnosticare un dispositivo in campo. |
| 16 | 16.1 | `listati/cap16/listato-16-01.ino` | Interrupt su fronte di discesa con debounce temporale. `millis()` è sicura da chiamare in una ISR sull'ESP32; `delay()` e `Serial` no. |
| 16 | 16.2 | `listati/cap16/listato-16-02.c` | Lo stesso interrupt in ESP-IDF. La ISR non fa lavoro: mette il numero del pin in una coda, e un task lo gestisce con calma. |
| 17 | 17.— | `listati/cap17/frammento-17-01.ino` | frammento (Attenuazioni e calibrazione) |
| 17 | 17.— | `listati/cap17/frammento-17-02.ino` | frammento (Ottenere misure decenti) |
| 17 | 17.— | `listati/cap17/frammento-17-03.c` | frammento (Misurare la tensione della batteria) |
| 17 | 17.— | `listati/cap17/frammento-17-04.ino` | frammento (DAC) |
| 17 | 17.— | `listati/cap17/frammento-17-05.ino` | frammento (Touch capacitivo) |
| 17 | 17.1 | `listati/cap17/listato-17-01.c` | Lettura calibrata in ESP-IDF. Lo schema *curve fitting* è disponibile sui chip recenti; sull'ESP32 classico si usa *line fitting*. |
| 18 | 18.— | `listati/cap18/frammento-18-01.c` | frammento (Un LED che sembri lineare) |
| 18 | 18.— | `listati/cap18/frammento-18-02.ino` | frammento (Servo ed ESC) |
| 18 | 18.1 | `listati/cap18/listato-18-01.ino` | Dissolvenza con LEDC nel core 3.x. Nel 2.x la stessa cosa richiedeva `ledcSetup` e `ledcAttachPin` con un numero di canale esplicito. |
| 18 | 18.2 | `listati/cap18/listato-18-02.ino` | LEDC in ESP-IDF. `ledc_set_duty` prepara il valore, `ledc_update_duty` lo applica: separati per poter cambiare più canali nello stesso istante. |
| 18 | 18.3 | `listati/cap18/listato-18-03.c` | Il nucleo di una configurazione MCPWM con tempo morto di 2 microsecondi fra le due uscite. L'esempio completo è nel repository del libro, sotto `cap18/ponte_h`. |
| 19 | 19.1 | `listati/cap19/listato-19-01.ino` | Un timer che chiama una ISR ogni 100 millisecondi. La firma di `timerBegin` è cambiata nel core 3.x: prende la frequenza, non il numero del timer e il divisore. |
| 19 | 19.2 | `listati/cap19/listato-19-02.ino` | Un timer periodico con `esp_timer`. Funziona identico in Arduino e in ESP-IDF, e `esp_timer_get_time()` è il modo più preciso di misurare il tempo sull'ESP32. |
| 19 | 19.3 | `listati/cap19/listato-19-03.c` | Una striscia WS2812 con il componente `led_strip`, che sotto usa un canale RMT e un encoder dedicato. |
| 19 | 19.4 | `listati/cap19/listato-19-04.c` | Un encoder letto con PCNT: un canale conta i fronti di A e il livello di B decide il segno. Il filtro da 1 µs elimina i rimbalzi dei contatti. |
| 20 | 20.— | `listati/cap20/frammento-20-01.ino` | frammento (I2C) |
| 20 | 20.— | `listati/cap20/frammento-20-02.ino` | frammento (I2C) |
| 20 | 20.1 | `listati/cap20/listato-20-01.c` | Lettura del registro ID di un BME280 in ESP-IDF. Ogni dispositivo sul bus è un oggetto con il proprio indirizzo e la propria velocità. |
| 20 | 20.2 | `listati/cap20/listato-20-02.ino` | Una lettura SPI con un bus secondario e CS gestito a mano. `beginTransaction` fissa velocità, ordine dei bit e modo, e blocca il bus contro altri task. |
| 20 | 20.3 | `listati/cap20/listato-20-03.c` | Bus e dispositivo SPI in ESP-IDF. `length` è in bit; per trasferimenti fino a 4 byte si possono usare i campi `tx_data` e `rx_data` senza buffer esterni. |
| 20 | 20.4 | `listati/cap20/listato-20-04.ino` | Una seconda seriale su pin scelti. Il buffer di ricezione predefinito è di 256 byte; un GPS che manda frasi lunghe a raffica lo riempie. |
| 20 | 20.5 | `listati/cap20/listato-20-05.c` | Lettura per righe con la rilevazione di pattern. L'evento arriva quando il terminatore è nel buffer; `uart_pattern_pop_pos` dice dove. |
| 20 | 20.6 | `listati/cap20/listato-20-06.c` | Invio e ricezione su CAN a 500 kbit/s. Il driver è lo stesso in Arduino, dove si include direttamente l'intestazione di ESP-IDF. |
| 21 | 21.1 | `listati/cap21/listato-21-01.ino` | Un misuratore di livello con un microfono I2S a 16 kHz. `I2S_MODE_PDM_RX` al posto di `I2S_MODE_STD` per un microfono PDM. |
| 22 | 22.1 | `listati/cap22/listato-22-01.ino` | Una tastiera USB che scrive una frase alla pressione di BOOT. `USBHIDMouse`, `USBHIDGamepad` e `USBHIDConsumerControl` per i tasti multimediali seguono lo stesso schema. |
| 22 | 22.2 | `listati/cap22/listato-22-02.ino` | Una scheda SD esposta come disco USB. Le due callback leggono e scrivono settori grezzi; il filesystem lo gestisce il computer. |
| 23 | 23.1 | `listati/cap23/listato-23-01.ino` | LVGL su un display SPI con TFT_eSPI. Il buffer di 20 righe è un compromesso fra memoria e velocità; con la PSRAM si può usare un fotogramma intero. |
| 23 | 23.2 | `listati/cap23/listato-23-02.ino` | Inizializzazione della camera con i pin dell'ESP32-CAM e cattura di un fotogramma JPEG. `fb_count = 2` con `CAMERA_GRAB_LATEST` tiene sempre pronto l'ultimo fotogramma. |
| 24 | 24.— | `listati/cap24/frammento-24-01.ino` | frammento (Station, AP e modalità mista) |
| 24 | 24.— | `listati/cap24/frammento-24-02.ino` | frammento (Wi-Fi 6 e i 5 GHz) |
| 24 | 24.1 | `listati/cap24/listato-24-01.ino` | Connessione a eventi. `loop()` non aspetta mai; se la rete cade, l'evento di disconnessione la riavvia. |
| 24 | 24.2 | `listati/cap24/listato-24-02.ino` | Riconnessione con backoff esponenziale e riavvio dopo un'ora. Da chiamare in `loop()` o da un task dedicato. |
| 24 | 24.3 | `listati/cap24/listato-24-03.ino` | WiFiManager: se le credenziali salvate funzionano, si connette; altrimenti apre il portale per tre minuti. |
| 24 | 24.4 | `listati/cap24/listato-24-04.ino` | Una scansione delle reti visibili. La versione asincrona, `scanNetworks(true)`, non blocca e si interroga con `scanComplete()`. |
| 24 | 24.5 | `listati/cap24/listato-24-05.ino` | Uno sniffer che stampa l'indirizzo sorgente e la potenza di ogni frame sul canale 6. La callback gira nel contesto dello stack: deve essere veloce, e in un progetto vero mette i dati in una coda. |
| 25 | 25.1 | `listati/cap25/listato-25-01.ino` | Un GET con timeout e gestione dell'errore. `http.end()` va chiamata sempre, anche in caso di errore, o la connessione resta aperta. |
| 25 | 25.2 | `listati/cap25/listato-25-02.c` | Un GET HTTPS in ESP-IDF con il bundle di certificati. La callback riceve il corpo a pezzi, che è il modo giusto di gestire risposte grandi. |
| 25 | 25.3 | `listati/cap25/listato-25-03.ino` | HTTPS con il bundle di certificati. In ESP-IDF è `esp_crt_bundle_attach` nella configurazione del client, e l'opzione *Certificate Bundle* in `menuconfig`. |
| 25 | 25.4 | `listati/cap25/listato-25-04.ino` | Un server asincrono con file statici da LittleFS e due API JSON. Le pagine HTML, CSS e JavaScript stanno nel filesystem, non nel codice. |
| 25 | 25.5 | `listati/cap25/listato-25-05.c` | Streaming MJPEG dalla camera. Il ciclo esce quando il browser chiude la pagina; ogni client occupa un task del server, che per default ne ha pochi. |
| 25 | 25.6 | `listati/cap25/listato-25-06.ino` | Un WebSocket che spinge la temperatura dieci volte al secondo a tutti i browser collegati e riceve comandi. Dal browser: `new WebSocket("ws://" + location.host + "/ws")`. |
| 25 | 25.7 | `listati/cap25/listato-25-07.ino` | Ora di rete con il fuso italiano e l'ora legale automatica. La stringa del fuso è nel formato POSIX; quella dell'Italia è questa. |
| 26 | 26.1 | `listati/cap26/listato-26-01.ino` | Un client con last will, riconnessione temporizzata, stato retained e conferma dei comandi. `setBufferSize(1024)` è necessario per i messaggi di discovery del paragrafo successivo. |
| 26 | 26.2 | `listati/cap26/listato-26-02.c` | Il client di ESP-IDF con TLS, last will e riconnessione automatica, che il driver gestisce da solo. In Arduino si può usare lo stesso client includendo `mqtt_client.h`. |
| 26 | 26.3 | `listati/cap26/listato-26-03.ino` | Un annuncio di discovery per un sensore di temperatura. Pubblicato retained, sopravvive ai riavvii di Home Assistant. Le chiavi abbreviate sono quelle documentate. |
| 26 | 26.4 | `listati/cap26/listato-26-04.yaml` | Un dispositivo ESPHome completo. Compilato e caricato dall'interfaccia di Home Assistant, aggiornabile via OTA da lì. |
| 27 | 27.1 | `listati/cap27/listato-27-01.ino` | Un ponte seriale Bluetooth sull'ESP32 classico. Da Android, qualunque app di terminale Bluetooth lo vede. |
| 27 | 27.2 | `listati/cap27/listato-27-02.ino` | Un server con il servizio standard *Environmental Sensing*: le app generiche mostrano la temperatura senza configurazione. La lettura richiede cifratura e il pairing con passkey. |
| 27 | 27.3 | `listati/cap27/listato-27-03.ino` | Una scansione continua che stampa ogni dispositivo visto. I dati di servizio nell'advertising contengono, per molti sensori, la misura in chiaro o cifrata con una chiave nota. |
| 27 | 27.4 | `listati/cap27/listato-27-04.ino` | Un client che si connette al server del listato 27.2 e si abbona alle notifiche. La connessione resta aperta finché non si chiama `disconnect()`. |
| 28 | 28.— | `listati/cap28/frammento-28-01.sh` | frammento (Thread) |
| 28 | 28.1 | `listati/cap28/listato-28-01.ino` | Una luce Zigbee su un C6 con la libreria Arduino. Il dispositivo appare in Zigbee2MQTT o in un hub commerciale come una luce generica. |
| 28 | 28.2 | `listati/cap28/listato-28-02.ino` | Una luce Matter su Wi-Fi con la libreria Arduino. Il codice di abbinamento si stampa sulla seriale; l'app Home lo accetta. |
| 29 | 29.1 | `listati/cap29/listato-29-01.ino` | Un mittente ESP-NOW. Il ricevente registra `esp_now_register_recv_cb` e riceve la struttura così com'è: le due parti devono avere la stessa definizione. |
| 29 | 29.2 | `listati/cap29/listato-29-02.ino` | Il ricevente. Non deve registrare il mittente come peer per ricevere; deve farlo solo se vuole rispondergli. |
| 30 | 30.— | `listati/cap30/frammento-30-01.c` | frammento (I modi di sonno) |
| 30 | 30.— | `listati/cap30/frammento-30-02.txt` | frammento (Costruire un budget energetico) |
| 30 | 30.— | `listati/cap30/frammento-30-03.txt` | frammento (Costruire un budget energetico) |
| 30 | 30.1 | `listati/cap30/listato-30-01.ino` | Light sleep esplicito: cinque secondi o un pulsante, e la RAM è intatta al risveglio. Il Wi-Fi, se connesso, va spento prima o si perde la connessione. |
| 30 | 30.2 | `listati/cap30/listato-30-02.ino` | Un sensore che dorme dieci minuti, si sveglia con il timer o con un pulsante, e trasmette solo se la temperatura è cambiata o una volta l'ora. Le due variabili in RTC RAM sono l'unica memoria fra un ciclo e l'altro. |
| 30 | 30.3 | `listati/cap30/listato-30-03.ino` | Connessione rapida con canale e BSSID conservati in RTC RAM e IP statico. Se fallisce, il ciclo successivo fa una connessione normale e aggiorna la cache. |
| 31 | 31.— | `listati/cap31/frammento-31-01.sh` | frammento (LittleFS, SPIFFS, FAT) |
| 31 | 31.— | `listati/cap31/frammento-31-02.ino` | frammento (Scheda SD) |
| 31 | 31.— | `listati/cap31/frammento-31-03.ino` | frammento (Log persistenti) |
| 31 | 31.1 | `listati/cap31/listato-31-01.ino` | Lettura e scrittura in NVS. Le chiavi sono limitate a 15 caratteri; i namespace separano le impostazioni di moduli diversi. |
| 31 | 31.2 | `listati/cap31/listato-31-02.c` | NVS in ESP-IDF. `nvs_commit` rende permanenti le scritture; `Preferences` lo chiama da sola. I due errori all'inizializzazione si gestiscono cancellando la partizione, cosa che succede dopo un cambio di versione del formato. |
| 31 | 31.3 | `listati/cap31/listato-31-03.ino` | LittleFS: montaggio, scrittura in append, elenco dei file. L'API `File` è la stessa di SD e di SPIFFS, quindi il codice si sposta fra i tre senza modifiche. |
| 32 | 32.— | `listati/cap32/frammento-32-01.sh` | frammento (Secure Boot v2) |
| 33 | 33.1 | `listati/cap33/listato-33-01.ino` | La conferma del nuovo firmware. `tuttoFunziona()` deve verificare ciò che conta davvero: connessione, comunicazione con il server, sensori. Una conferma incondizionata all'avvio rende il rollback inutile. |
| 33 | 33.2 | `listati/cap33/listato-33-02.ino` | ArduinoOTA. Dopo il primo caricamento via USB, il dispositivo compare in `Tools → Port` come porta di rete. PlatformIO lo usa con `upload_protocol = espota` e `upload_port = salotto-1.local`. |
| 33 | 33.3 | `listati/cap33/listato-33-03.ino` | Controllo della versione e aggiornamento da HTTPS. Il file `latest.txt` contiene solo il numero di versione; il dispositivo scarica il binario solo se diverso dal proprio. |
| 33 | 33.4 | `listati/cap33/listato-33-04.c` | OTA da HTTPS in ESP-IDF con controllo della versione prima di scrivere. La versione viene dal `CMakeLists.txt` (`PROJECT_VER`) o da un file `version.txt` nel progetto. |
| 35 | 35.— | `listati/cap35/frammento-35-01.ino` | frammento (Profiling) |
| 35 | 35.1 | `listati/cap35/listato-35-01.ino` | Lettura del riepilogo del core dump al riavvio. L'immagine completa si legge con `esp_core_dump_image_get()` e si spedisce come blob. |
| 35 | 35.2 | `listati/cap35/listato-35-02.c` | Due test Unity per un filtro. Si eseguono sul chip con l'app di test di ESP-IDF, oppure su Linux. |
| 36 | 36.— | `listati/cap36/frammento-36-01.csv` | frammento (Provisioning di massa) |
| 36 | 36.— | `listati/cap36/frammento-36-02.sh` | frammento (Provisioning di massa) |
| 37 | 37.1 | `listati/cap37/listato-37-01.ino` | Il nucleo del sensore. `connettiVeloce()` è il listato 30.3; `mqttConnetti()` il 26.1 senza il ciclo di riconnessione. Un ciclo completo con trasmissione dura circa 900 ms. |
| 37 | 37.2 | `listati/cap37/listato-37-02.ino` | Il `loop()` del nodo. Lo stato del relè è salvato in NVS e ripristinato all'avvio, così un black-out non spegne la lampada. |
| 37 | 37.3 | `listati/cap37/listato-37-03.c` | Il task LVGL e l'aggiornamento dell'interfaccia dallo stato ricevuto. LVGL non è thread-safe: ogni accesso da un task diverso passa dal mutex. |
| 37 | 37.4 | `listati/cap37/listato-37-04.c` | La struttura di un dispositivo `esp-matter`: un nodo, due endpoint, una callback per gli attributi che il controller scrive. La rete Thread e il commissioning sono gestiti dal framework. |
| 37 | 37.5 | `listati/cap37/listato-37-05.ino` | Il sensore Zigbee a batteria con la libreria Arduino. Il risveglio è sul fronte opposto allo stato attuale, così ogni cambio sveglia il chip. |
| 37 | 37.6 | `listati/cap37/listato-37-06.ino` | Il task di rilevamento sulla pipeline a bassa risoluzione, con un intervallo minimo di trenta secondi fra due eventi. Lo stream 720p gira su una pipeline separata e non è influenzato. |
| 37 | 37.7 | `listati/cap37/listato-37-07.ino` | Il ciclo del data logger. Il ridisegno dell'e-paper è la fase costosa e avviene una volta l'ora; la scrittura su SD dura 100 ms. |
