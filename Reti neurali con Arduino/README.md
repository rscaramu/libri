# Reti neurali con Arduino — Dal primo sensore al modello in produzione

Codice, modelli e materiali del libro *Reti neurali con Arduino* (Roberto Scaramuzzino, 2026). TinyML con Nano 33 BLE Sense Rev2, XIAO ESP32S3 Sense, Edge Impulse e LiteRT for Microcontrollers.

## Struttura

```
listati/capNN/       ogni listato del libro, un file, con la didascalia in testa
frammenti/capNN/     i frammenti senza numero
progetti/            sketch completi per due schede, modelli e script di addestramento
  iris/  gesti/  cadute/  vibrazioni/  parola/  oggetti/  stazione/  energia/  aggiornamento/
  README.md          tabella di copertura e comandi arduino-cli
  COMPILAZIONE.md    esito e dimensioni di tutte le compilazioni (settembre 2026)
notebook/            00-python-in-un-ora, 11-gesti, 14-16-progetti, 17-oggetti (Colab)
strumenti/           bmi270-anymotion.ino (cap. 21), fft-verifica.py (cap. 15), registro.py (cap. 20)
```

## Le due schede

| | Nano 33 BLE Sense Rev2 | XIAO ESP32S3 Sense |
|---|---|---|
| FQBN | `arduino:mbed_nano:nano33ble` | `esp32:esp32:XIAO_ESP32S3` |
| Sensori | IMU e microfono a bordo | camera e microfono a bordo; IMU MPU6050 esterno su I²C (D4/D5) |
| Capitoli narranti | 9–16 | 17–18 |

Ogni progetto ha una cartella `nano33/` e una `esp32s3/`; lo stesso `.tflite` gira su entrambe (unità comuni: g e gradi/s). Le vibrazioni sono l'eccezione (100 Hz sulla Nano, 1 kHz sull'S3, due modelli).

## Versioni verificate

arduino-cli 1.5.1 · `arduino:mbed_nano` 4.6.0 · `esp32` 3.3.11 · ArduTFLite 1.0.2 · Chirale_TensorFlowLite 2.0.0 · Arduino_BMI270_BMM150 1.2.4 · Adafruit MPU6050 2.2.9 · ArduinoBLE 2.1.0 · arduinoFFT 2.0.4 · TensorFlow 2.21 / Keras 3 · edge-impulse-cli 1.39.3. Tutti i 29 sketch compilano con queste versioni; le misure sono in `progetti/COMPILAZIONE.md`.

## I modelli

I modelli nel repository sono addestrati su **dati sintetici** con la firma fisica descritta nei capitoli: servono a verificare la catena (conversione, op, dimensioni, quantizzazione) e a far girare gli sketch subito. Il modello vero nasce dai dati raccolti come nel capitolo 10: si rilanciano gli script su propri CSV.

| Modello | Parametri | `.tflite` int8 | Op |
|---|---|---|---|
| gesti 384→32→3 | 12.419 | 15.400 B | FULLY_CONNECTED, SOFTMAX |
| cadute Conv1D | 2.604 | 11.944 B | EXPAND_DIMS, CONV_2D, RESHAPE, MAX_POOL_2D, MEAN, FULLY_CONNECTED, SOFTMAX |
| anomalie autoencoder | 2.276 | 7.800 B | FULLY_CONNECTED |
| parola Conv2D | 3.556 | 7.752 B | CONV_2D, MAX_POOL_2D, RESHAPE, FULLY_CONNECTED, SOFTMAX |
| oggetti MobileNetV2 0.35 | 415.332 | 644.336 B | CONCATENATION, CONV_2D, DEPTHWISE_CONV_2D, ADD, MEAN, FULLY_CONNECTED, SOFTMAX |

Le librerie esportate da Edge Impulse (`*_inferencing`) non sono nel repository: si generano dal proprio progetto in Studio (capitolo 12).

## Errata

Nessuna segnalazione al momento. Gli errori si segnalano con una *issue*, indicando pagina o numero di listato.

## Licenza

MIT (vedi `LICENSE`). I marchi citati appartengono ai rispettivi proprietari.
