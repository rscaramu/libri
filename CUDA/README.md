# Manuale completo di CUDA — materiali per i lettori

Codice degli esempi e prompt per l’IA del libro *Manuale completo di CUDA. Dalla programmazione parallela su GPU all’ottimizzazione delle prestazioni* di Roberto Scaramuzzino.

## Requisiti

- GPU NVIDIA con compute capability 6.0 o superiore (gli esempi sono pensati per Ampere e Ada)
- CUDA Toolkit 12.x con `nvcc`, driver aggiornato
- Linux, oppure Windows con WSL2 o Visual Studio

## Compilazione

Ogni file `.cu` è un programma completo:

```bash
nvcc -std=c++17 -O2 -arch=native file.cu -o file
./file
```

Gli esempi che usano librerie riportano nel libro le opzioni di collegamento (`-lcublas`, `-lcufft`, `-lcurand`, `-lcusparse`, `-lnccl`). I tempi stampati dipendono dalla GPU: confrontate i rapporti, non i valori assoluti.

## Contenuto

Una cartella per capitolo con gli esempi completi e, in `prompt_IA.txt`, i tre prompt della sezione «Con l’IA».

| Cap. | Titolo | Esempi |
|---:|---|---:|
| 1 | La GPU come calcolatore | 1 |
| 2 | Installazione e primo programma | 5 |
| 3 | Il modello di programmazione: kernel, thread, blocchi e griglie | 2 |
| 4 | Memoria host e device e gestione degli errori | 6 |
| 5 | Indicizzazione in due e tre dimensioni | 2 |
| 6 | Il C++ dentro CUDA | 2 |
| 7 | La gerarchia di memoria della GPU | 1 |
| 8 | Memoria globale e accessi coalescenti | 2 |
| 9 | Memoria condivisa e sincronizzazione | 1 |
| 10 | Registri, memoria locale, costante e texture | 3 |
| 11 | Memoria unificata, pinned e mappata | 7 |
| 12 | Operazioni atomiche | 2 |
| 13 | L’architettura in esecuzione: SM, warp e scheduler | 3 |
| 14 | Divergenza e primitive a livello di warp | 4 |
| 15 | Stream e concorrenza | 3 |
| 16 | Eventi, sincronizzazione e misura del tempo | 7 |
| 17 | Occupancy e configurazione del lancio | 3 |
| 18 | Cooperative groups e parallelismo dinamico | 4 |
| 19 | Pattern elementari: map, gather, scatter e stencil | 1 |
| 20 | Riduzione e scan | 2 |
| 21 | Istogrammi, compattazione e ordinamento | 2 |
| 22 | Moltiplicazione di matrici: dal kernel ingenuo al tiling | 1 |
| 23 | Thrust | 8 |
| 24 | Le librerie: cuBLAS, cuFFT, cuRAND, cuSPARSE | 4 |
| 25 | Metodologia di profilazione: Nsight Systems e Nsight Compute | 3 |
| 26 | Ottimizzare la memoria | 2 |
| 27 | Ottimizzare il calcolo | 2 |
| 28 | Debug e correttezza | 1 |
| 29 | Più GPU e sistemi distribuiti | 2 |
| 30 | CUDA da Python e interoperabilità | 10 |
| 31 | Progetto: simulazione N-body | 1 |
| 32 | Progetto: elaborazione di immagini | 1 |
| 33 | Progetto: una rete neurale su GPU | 2 |
| 34 | CUDA oggi e domani | 1 |

## Errata

Le correzioni segnalate dopo la pubblicazione sono elencate in `ERRATA.md`.

## Licenza

Il codice è distribuito con licenza MIT. Il testo del libro non è incluso.
