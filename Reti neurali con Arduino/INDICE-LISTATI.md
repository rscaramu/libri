| Cap. | File | Contenuto |
|---|---|---|
| 02 | `listato-02-01.txt` | Il conto del paragrafo 2.5 scritto come frammento C. Non fa nulla di u |
| 04 | `listato-04-01.txt` | Un albero decisionale su due feature diventa una funzione C di dieci r |
| 04 | `listato-04-02.txt` | Rilevamento di caduta a macchina a stati. Trenta righe, nessun dataset |
| 05 | `frammento-05-01.txt` |  |
| 05 | `listato-05-01.ino` | Inferenza completa di una rete 4→8→3 senza librerie. I pesi sono quell |
| 07 | `listato-07-01.py` | Conversione e quantizzazione int8 completa di un modello Keras. Le ult |
| 07 | `frammento-07-02.txt` |  |
| 07 | `frammento-07-03.ino` | L'header prodotto da xxd, con const e allineamento aggiunti. I primi b |
| 07 | `frammento-07-04.txt` | La struttura di ogni sketch di inferenza del libro. Le librerie di alt |
| 08 | `listato-08-01.ino` | Lo sketch minimo con ArduTFLite: quattro funzioni, modelInit, modelSet |
| 08 | `listato-08-02.txt` | Ambiente Python locale. L'ultima riga stampa la versione di TensorFlow |
| 09 | `listato-09-01.ino` | Lettura dell'accelerometro sulla Nano 33 BLE Sense Rev2. I valori sono |
| 09 | `listato-09-02.ino` | Lettura del microfono PDM. Ogni chiamata a onPDM porta 256 campioni a  |
| 09 | `listato-09-03.ino` | Il primo modello che gira: una rete 1→16→16→1 che approssima il seno,  |
| 09 | `frammento-09-05.txt` |  |
| 09 | `listato-09-04.ino` | La stessa lettura sull'ESP32-S3 con MPU6050. La libreria restituisce m |
| 09 | `frammento-09-06.txt` | La cartella di lavoro. Ogni progetto ha i dati, il codice Keras, e uno |
| 10 | `listato-10-01.ino` | Sketch di acquisizione per il data forwarder. È il listato 9.1 senza i |
| 10 | `listato-10-02.ino` | Sull'ESP32-S3 il loop è temporizzato a micros(), perché l'MPU6050 non  |
| 11 | `listato-11-01.py` | Caricamento del dataset esportato da Studio e taglio in finestre di 12 |
| 11 | `listato-11-02.py` | La rete 384→32→3 del capitolo 2, con dropout ed early stopping. Il con |
| 11 | `listato-11-03.py` | Conversione e quantizzazione int8. Le ultime quattro righe aprono il f |
| 11 | `listato-11-04.txt` | Da file binario a header C. La seconda riga aggiunge const e allineame |
| 12 | `listato-12-01.ino` | Inferenza con la libreria di Edge Impulse. La libreria calcola le feat |
| 12 | `listato-12-02.ino` | Inferenza con ArduTFLite e il modello Keras. modelSetInput riceve il v |
| 12 | `listato-12-03.ino` | Il setup con le classi del runtime. Il resolver registra solo FullyCon |
| 12 | `listato-12-04.ino` | Quantizzazione dell'ingresso e dequantizzazione dell'uscita. Due righe |
| 12 | `listato-12-05.txt` | Soglia e debouncing. Restituisce la classe una sola volta per gesto, q |
| 14 | `listato-14-01.ino` | Acquisizione a sei assi. Il giroscopio è diviso per 500 per portarlo n |
| 14 | `listato-14-02.py` | La rete convoluzionale 1D per le cadute. Tre coppie convoluzione-pooli |
| 14 | `listato-14-03.py` | Augmentation per segnali IMU: rumore, cambio di scala del 10%, spostam |
| 14 | `listato-14-04.ino` | Allarme BLE con ArduinoBLE. La scheda espone un servizio con una carat |
| 14 | `listato-14-05.ino` | L'allarme via Wi-Fi sull'S3: una richiesta HTTP a un webhook. Il Wi-Fi |
| 15 | `listato-15-01.ino` | L'acquisizione è quella del capitolo 10, con quattro decimali perché l |
| 15 | `listato-15-02.py` | Spettro e autoencoder in Keras. La rete impara a riprodurre l'ingresso |
| 15 | `listato-15-03.py` | La soglia sui dati normali: media più tre deviazioni standard. Con dat |
| 15 | `listato-15-04.ino` | Inferenza con l'autoencoder. La differenza dai progetti precedenti è l |
| 16 | `listato-16-01.ino` | Doppio buffer per l'audio. L'interrupt riempie un buffer; quando è pie |
| 16 | `listato-16-02.py` | La rete per il keyword spotting. Due coppie convoluzione-pooling e uno |
| 16 | `listato-16-03.ino` | Keyword spotting continuo con la libreria di Edge Impulse. Ogni 250 ms |
| 16 | `listato-16-04.ino` | Il microfono della XIAO ESP32S3 Sense. La lettura è bloccante e a poll |
| 17 | `listato-17-01.ino` | Configurazione della camera. Scala di grigi a un byte per pixel, QVGA, |
| 17 | `listato-17-02.ino` | Raccolta immagini su microSD. Ogni scatto salva un file PGM, il format |
| 17 | `listato-17-03.py` | Transfer learning in due fasi: prima si addestra solo lo strato finale |
| 17 | `listato-17-04.ino` | Classificazione di immagini con la libreria di Edge Impulse. La funzio |
| 17 | `frammento-17-07.ino` | L'inferenza con ESP-DL, in sei righe. Il modello sta in una partizione |
| 18 | `listato-18-01.txt` | La logica di combinazione. Stato condiviso, finestre temporali, veto.  |
| 18 | `listato-18-02.txt` | Il protocollo fra le schede. Righe di testo, un parser di dieci righe, |
| 18 | `listato-18-03.ino` | La visione in un task FreeRTOS sul secondo core dell'S3. Il task dorme |
| 19 | `frammento-19-08.py` |  |
| 19 | `frammento-19-09.txt` | L'analyzer stampa ogni op del modello con i suoi tensori, le dimension |
| 20 | `frammento-20-10.ino` | La riga da mettere in ogni sketch, dopo la prima inferenza. Con la lib |
| 20 | `frammento-20-11.ino` | Il profiler del runtime. Log stampa il tempo di ogni op nell'ordine di |
| 20 | `frammento-20-12.txt` |  |
| 20 | `listato-20-01.txt` | Il registro degli eventi. Otto finestre in un buffer circolare, con or |
| 21 | `frammento-21-13.txt` |  |
| 21 | `listato-21-01.ino` | Sonno profondo del nRF52840. La scheda consuma 40–60 µA e riparte da c |
| 21 | `listato-21-02.ino` | I due sonni dell'ESP32-S3. Il deep sleep con risveglio dal pin o dal t |
| 22 | `listato-22-01.csv` | Tabella delle partizioni per l'S3 con 8 MB di Flash: due partizioni pe |
| 22 | `frammento-22-14.txt` | L'intestazione di 16 byte davanti al modello. Il campo versioneFeature |
| 22 | `listato-22-02.ino` | Caricamento del modello dalla partizione sull'S3. Quattro controlli pr |
| 22 | `listato-22-03.txt` | Aggiornamento del modello via HTTP sull'S3. Scarica nella partizione l |
| 22 | `listato-22-04.txt` | Aggiornamento via BLE sulla Nano: una caratteristica per i dati e una  |
| 23 | `listato-23-01.py` | Il lato Python del rilevatore di cadute in App Lab. Il modello gira su |
| A | `listato-A-01.txt` | Le due funzioni del paragrafo 12.4, da copiare in ogni sketch che usa  |
| E | `frammento-E-15.txt` | La struttura del repository. Ogni progetto ha i dati di esempio del pr |