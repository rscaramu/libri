# Reti neurali con Arduino — Dal primo sensore al modello in produzione

Codice, modelli e materiali del libro *Reti neurali con Arduino* (Roberto Scaramuzzino, 2026). TinyML con Nano 33 BLE Sense Rev2, XIAO ESP32S3 Sense, Edge Impulse e LiteRT for Microcontrollers.

## Materiale effettivamente pubblicato

I file sono direttamente in questa directory: non sono presenti le directory `listati/capNN/`, `frammenti/capNN/`, `progetti/`, `notebook/` e `strumenti/` descritte in precedenza. Anche le strutture mostrate nei frammenti del libro sono esempi organizzativi, non percorsi disponibili nel repository.

| File nella directory del manuale | Uso |
|---|---|
| [INDICE-LISTATI.md](INDICE-LISTATI.md) | Corrispondenza fra capitoli, listati e frammenti; i nomi indicati sono relativi a questa directory |
| `listato-*`, `frammento-*` | Materiale didattico: non tutti i listati sono programmi autonomi |
| `09-*.ino`, `10-acquisizione.ino`, `12-*.ino`, `17-*.ino`, `22-*.ino`, `bmi270-anymotion.ino` | Esempi con struttura di sketch, da preparare singolarmente come spiegato sotto |
| `00-python-in-un-ora.ipynb`, `11-gesti.ipynb`, `14-16-progetti.ipynb`, `17-oggetti.ipynb` | Notebook, nella stessa directory degli script |
| [train-gesti.py](train-gesti.py), [train-progetti.py](train-progetti.py), [train-oggetti.py](train-oggetti.py) | Addestramento e conversione su dati sintetici (Iris usa il dataset reale incluso in scikit-learn) |
| [fft-verifica.py](fft-verifica.py), [registro.py](registro.py) | Confronto FFT e lettura del registro seriale |
| `*.h`, `oggetti.tflite`, `partitions.csv`, `main.cpp`, `CMakeLists*.txt` | Header, modello e materiale per configurazioni specifiche |

Non esiste `progetti/COMPILAZIONE.md`; non è disponibile qui un rapporto con gli esiti e le dimensioni delle compilazioni. I file con suffissi come ` (3)` o ` (5)` sono copie pubblicate: gli include degli esempi usano i nomi senza suffisso. Non sostituirli automaticamente né presumere che le copie siano equivalenti.

## Le due schede

| | Nano 33 BLE Sense Rev2 | XIAO ESP32S3 Sense |
|---|---|---|
| FQBN | `arduino:mbed_nano:nano33ble` | `esp32:esp32:XIAO_ESP32S3` |
| Sensori | IMU e microfono a bordo | Camera e microfono a bordo; IMU MPU6050 esterno su I²C (D4/D5) |
| Capitoli narranti | 9–16 | 17–18 |

Non sono pubblicate cartelle `nano33/` e `esp32s3/` per ogni progetto. Scegliere l'esempio in base ai suoi include e al sensore effettivo: per esempio `09-imu-mpu6050.ino` e `10-acquisizione.ino` usano MPU6050, mentre `listato-09-01.ino` usa l'IMU della Nano. Per riutilizzare un modello occorre mantenere identici unità, ordine degli assi, frequenza, finestre e normalizzazione. Le vibrazioni descritte nel libro hanno frequenze diverse (100 Hz sulla Nano, 1 kHz sull'S3): non assumere che il modello sintetico dello script a 100 Hz copra entrambe.

## Sketch completi ed estratti didattici

L'estensione `.ino` e il prefisso `listato-` non garantiscono uno sketch autonomo. Consultare l'indice e leggere il sorgente prima di compilarlo.

- Esempi con `setup()` e `loop()` e header locali disponibili: `09-seno.ino`, `12-inferenza-ardutflite.ino`, `12-inferenza-chirale.ino`, `12-riferimento.ino`, `17-raccolta.ino`, `17-inferenza.ino`. Servono comunque scheda, librerie e configurazione corretti; questa classificazione deriva dalla lettura, non da una compilazione.
- Alcuni listati sono anch'essi sketch strutturati, per esempio `listato-05-01.ino`, `listato-09-01.ino`, `listato-10-01.ino` e `listato-12-02.ino`.
- Estratti da integrare: per esempio `listato-12-03.ino` contiene il setup del runtime senza loop, `listato-12-04.ino` il solo loop, `listato-14-04.ino` le funzioni BLE, `listato-15-04.ino` la funzione di inferenza. I file `frammento-*` sono porzioni didattiche, non sketch da compilare da soli.
- Gli esempi Edge Impulse richiedono librerie esportate dal proprio progetto Studio: `gesti_inferencing.h`, `parola_inferencing.h`, `oggetti_inferencing.h` non sono inclusi.
- `listato-08-01.ino` richiede `modello.h`, da produrre dal proprio modello; `listato-17-01.ino` cita `camera_pins.h`, non pubblicato con quel nome. L'esempio `17-raccolta.ino` usa invece l'header disponibile `camera_xiao.h`: non rinominare un header senza confrontarne simboli e pin.
- `listato-15-04.ino` richiede `ae_modello.h` e `ae_norm.h`, generati da `train-progetti.py`. `main.cpp` e i CMake sono materiale strutturale ESP-IDF/ESP-DL, non un progetto Arduino autonomo; richiedono anche configurazione della camera e modello appropriato.

Arduino compila insieme i file `.ino` di una cartella: **non aprire l'intera directory del manuale come un unico sketch**. Copiare un solo esempio in una cartella di lavoro con lo stesso nome del file e aggiungere soltanto gli header necessari. Per esempio, dalla directory del manuale, con shell POSIX:

```sh
mkdir -p /tmp/arduino-esempi/09-seno
cp 09-seno.ino modello_seno.h /tmp/arduino-esempi/09-seno/
arduino-cli compile --fqbn arduino:mbed_nano:nano33ble /tmp/arduino-esempi/09-seno
```

Il comando è un'istruzione da eseguire dopo l'installazione del core e di ArduTFLite, non un risultato di compilazione. Per gli altri esempi copiare gli header nominati negli include, ad esempio `gesti_modello.h` e, per `12-riferimento.ino`, anche `gesti_riferimento.h`. Per `17-inferenza.ino` servono `camera_xiao.h` e `oggetti_modello.h`. Gli esempi OTA richiedono inoltre partizioni, indirizzi di rete e configurazioni coerenti con il sorgente.

## Dipendenze e versioni dichiarate

La documentazione precedente riportava: arduino-cli 1.5.1, `arduino:mbed_nano` 4.6.0, `esp32` 3.3.11, ArduTFLite 1.0.2, Chirale_TensorFlowLite 2.0.0, Arduino_BMI270_BMM150 1.2.4, Adafruit MPU6050 2.2.9, ArduinoBLE 2.1.0, arduinoFFT 2.0.4, TensorFlow 2.21 / Keras 3 ed edge-impulse-cli 1.39.3. Sono riferimenti storici dichiarati, non versioni nuovamente collaudate in questa revisione.

Installare le librerie in base agli include dell'esempio scelto, incluse le dipendenze Adafruit BusIO e Adafruit Unified Sensor per MPU6050. `Wire`, PDM e le API specifiche ESP32/mbed dipendono dal core selezionato; ArduTFLite e Chirale sono runtime alternativi usati da esempi distinti. L'esempio ESP-DL richiede ESP-IDF 5.5 e il componente `espressif/esp-dl`, come indicato nei CMake, oltre alla preparazione del progetto.

## Eseguire Python

Tutti i percorsi degli script sono relativi alla **directory corrente di esecuzione**, non automaticamente alla posizione del file. Dalla radice del clone:

```sh
cd "Reti neurali con Arduino"
python -m venv .venv
# Linux/macOS:
. .venv/bin/activate
# Windows PowerShell, in alternativa: .\.venv\Scripts\Activate.ps1
python -m pip install numpy tensorflow scikit-learn pandas pyserial
```

Usare una versione di Python supportata dal TensorFlow installato. Questi pacchetti derivano dagli import presenti; non è pubblicato un lockfile che garantisca la riproducibilità. Gli script usano `tf.lite.Interpreter` e API di conversione Keras: verificare la compatibilità dell'ambiente scelto. Keras è importato tramite TensorFlow; `pyserial` fornisce il modulo `serial`.

| Comando dalla directory del manuale | Prerequisiti e output |
|---|---|
| `python train-gesti.py` | NumPy, TensorFlow, scikit-learn; crea `modelli/` e scrive `pesi-iris.h`, `gesti-test.csv`, `gesti.tflite`, `gesti_modello.h`, `gesti_riferimento.h` al suo interno |
| `python train-progetti.py` | NumPy, TensorFlow; legge `train-gesti.py` per estrarne due funzioni, senza eseguirne l'addestramento; crea `modelli/` e scrive `cadute.tflite`, `cadute_modello.h`, `ae.tflite`, `ae_modello.h`, `ae_norm.h`, `parola.tflite`, `parola_modello.h` |
| `python train-oggetti.py` | NumPy, TensorFlow e `train-gesti.py` nella directory corrente; richiede `modelli/` già esistente e accesso ai pesi ImageNet al primo download; scrive `modelli/oggetti.tflite` e `modelli/oggetti_modello.h` |
| `python fft-verifica.py` | Solo NumPy; stampa lo spettro e scrive `finestra_verifica.h` nella directory corrente |
| `python registro.py /dev/ttyACM0 0.00784 -1` | NumPy, pyserial, scheda collegata e firmware che risponda a `R` con il protocollo previsto; scrive `registro.csv` nella directory corrente |

Per l'addestramento degli oggetti eseguito da solo, prima creare la directory in modo portabile:

```sh
python -c "from pathlib import Path; Path('modelli').mkdir(exist_ok=True)"
python train-oggetti.py
```

Su Windows sostituire `/dev/ttyACM0` con la porta effettiva, per esempio `COM3`. Scala e zero point nel comando di `registro.py` sono esempi: usare quelli del proprio modello. Gli script possono sovrascrivere gli output omonimi; copiare gli header generati nella cartella dello sketch scelto, mantenendo insieme modello, normalizzazione e vettori di riferimento della stessa esecuzione. Gli header già pubblicati nella directory principale non vengono aggiornati automaticamente.

I `listato-*.py` sono spesso passaggi di una sessione condivisa: `listato-07-01.py` presuppone `modello` e `X_train`; `listato-11-02.py` e `listato-11-03.py` usano lo stato prodotto da `listato-11-01.py`. Per il capitolo 11 occorrono esportazioni JSON Edge Impulse in `training/` e `testing/`, directory non incluse. In una sessione Python interattiva avviata qui, dopo aver preparato i dati:

```python
exec(open("listato-11-01.py", encoding="utf-8").read())
exec(open("listato-11-02.py", encoding="utf-8").read())
exec(open("listato-11-03.py", encoding="utf-8").read())
```

L'ultimo passaggio scrive `gesti.tflite` nella directory corrente. Gli altri listati di addestramento richiedono analogamente import e dataset dal contesto del capitolo; non basta avviarli come script separati. `listato-23-01.py` richiede Edge Impulse Linux, Arduino App Lab, `cadute.eim` e una funzione `notifica` da integrare; il sorgente stesso segnala che le API Bridge vanno verificate.

Per i notebook installare anche Jupyter (`python -m pip install jupyterlab`) e avviare `python -m jupyterlab` da questa directory. Eseguire le celle in ordine. `14-16-progetti.ipynb` e `17-oggetti.ipynb` leggono anch'essi `train-gesti.py`; per il notebook oggetti creare prima `modelli/`. In Colab caricare i file necessari nella directory di lavoro del runtime: aprire il solo notebook non trasferisce gli script ausiliari. Il notebook introduttivo scrive anche `finestra.csv`.

## I modelli

Gli script `train-*` usano **dati sintetici**, salvo Iris: verificano la catena di addestramento/conversione e non dimostrano prestazioni sul campo. Non accettano direttamente CSV personali: per dati reali adattare il caricamento e la preparazione delle feature, oppure partire dai listati del capitolo 11 per gli export JSON. Conservare la stessa preparazione dei dati anche sul microcontrollore.

La tabella seguente riporta le misure dichiarate nella documentazione precedente, non ricalcolate in questa revisione; gli artefatti rigenerati possono differire.

| Modello | Parametri | `.tflite` int8 | Op |
|---|---|---|---|
| gesti 384→32→3 | 12.419 | 15.400 B | FULLY_CONNECTED, SOFTMAX |
| cadute Conv1D | 2.604 | 11.944 B | EXPAND_DIMS, CONV_2D, RESHAPE, MAX_POOL_2D, MEAN, FULLY_CONNECTED, SOFTMAX |
| anomalie autoencoder | 2.276 | 7.800 B | FULLY_CONNECTED |
| parola Conv2D | 3.556 | 7.752 B | CONV_2D, MAX_POOL_2D, RESHAPE, FULLY_CONNECTED, SOFTMAX |
| oggetti MobileNetV2 0.35 | 415.332 | 644.336 B | CONCATENATION, CONV_2D, DEPTHWISE_CONV_2D, ADD, MEAN, FULLY_CONNECTED, SOFTMAX |

Il binario `oggetti.tflite` è pubblicato qui; non tutti gli altri binari della tabella sono presenti, anche quando è disponibile un header. Le librerie esportate da Edge Impulse (`*_inferencing`) si generano dal proprio progetto Studio (capitolo 12).

## Controlli della documentazione

Revisione del 19 ottobre 2026: controllati albero dei file, riferimenti locali del README e nomi dei file nell'indice; letti import, include e percorsi di input/output degli esempi. Controllata la sintassi dei 17 file Python e delle celle di codice dei 4 notebook. Eseguito `fft-verifica.py` in una directory temporanea, verificando la creazione dell'header e il picco al bin 64.

La precedente affermazione «tutti i 29 sketch compilano» non viene confermata da questi controlli: non è presente il rapporto citato e qui sono pubblicati 42 file `.ino`, comprendenti estratti e varianti. Non sono state eseguite nuove compilazioni Arduino (arduino-cli non disponibile nell'ambiente di revisione), addestramenti TensorFlow (pacchetto non disponibile), prove seriali o su hardware. La correttezza sintattica Python non dimostra l'esecuzione completa né la disponibilità dei dataset.

## Errata e licenza

Segnalare gli errori con una *issue*, indicando file, pagina o numero di listato e ambiente usato. Licenza MIT: vedere [LICENSE](LICENSE). I marchi citati appartengono ai rispettivi proprietari.
