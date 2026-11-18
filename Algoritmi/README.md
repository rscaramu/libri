# Algoritmi

Materiale per i lettori del volume *Algoritmi — Dai fondamenti alle tecniche avanzate, con pseudocodice e Python* di Roberto Scaramuzzino.

## Che cosa contiene

- `python/` — il codice Python del libro, un file per capitolo, con i blocchi nell'ordine in cui compaiono.
- `pseudocodice/` — lo pseudocodice di ogni capitolo, in testo semplice.
- `prompt/` — le richieste per l'assistente IA proposte alla fine di ogni capitolo, pronte da copiare.
- `esegui_tutto.py` — esegue tutti i capitoli e segnala quelli che non terminano correttamente.
- `RISORSE.md` — le risorse in rete citate nell'appendice F.
- `ERRATA.md` — le correzioni segnalate dopo la pubblicazione.

Il testo del libro non è incluso.

## Come usare gli esempi

Serve Python 3.10 o successivo; il codice usa soltanto la libreria standard. Ogni file si esegue da solo e stampa le uscite riportate nel libro:

```console
python3 python/cap16.py
```

Per eseguirli tutti:

```console
python3 esegui_tutto.py
```

Le uscite del libro sono state ottenute con Python 3.13. I programmi che usano numeri casuali fissano il seme, quindi le uscite sono riproducibili; i tempi di esecuzione, dove compaiono, dipendono dalla macchina.

Il codice privilegia la leggibilità: nomi in italiano, nessuna dipendenza esterna, righe di 62 caratteri al massimo. Dove la libreria standard offre già l'algoritmo, il libro lo scrive comunque per esteso e lo segnala nel testo.

Nello pseudocodice l'assegnamento è `<-`, gli indici partono da 0 e gli intervalli comprendono gli estremi; l'appendice D del libro spiega come tradurlo in C, C++, Java, C#, JavaScript, Go e Rust.

## Indice

| Cap. | Titolo | Python | Pseudocodice | Prompt |
|---|---|---|---|---|
| 1 | Che cos’è un algoritmo | [python](python/cap01.py) | [pseudocodice](pseudocodice/cap01.txt) | [prompt](prompt/cap01.md) |
| 2 | Pseudocodice e Python: le convenzioni del libro | [python](python/cap02.py) | [pseudocodice](pseudocodice/cap02.txt) | [prompt](prompt/cap02.md) |
| 3 | Correttezza: invarianti e induzione | [python](python/cap03.py) | [pseudocodice](pseudocodice/cap03.txt) | [prompt](prompt/cap03.md) |
| 4 | Analisi della complessità e notazione asintotica | [python](python/cap04.py) | [pseudocodice](pseudocodice/cap04.txt) | [prompt](prompt/cap04.md) |
| 5 | Ricorsione e relazioni di ricorrenza | [python](python/cap05.py) | [pseudocodice](pseudocodice/cap05.txt) | [prompt](prompt/cap05.md) |
| 6 | Analisi ammortizzata e caso medio | [python](python/cap06.py) | [pseudocodice](pseudocodice/cap06.txt) | [prompt](prompt/cap06.md) |
| 7 | Array, liste concatenate e array dinamici | [python](python/cap07.py) | [pseudocodice](pseudocodice/cap07.txt) | [prompt](prompt/cap07.md) |
| 8 | Pile, code e deque | [python](python/cap08.py) | [pseudocodice](pseudocodice/cap08.txt) | [prompt](prompt/cap08.md) |
| 9 | Tabelle hash | [python](python/cap09.py) | [pseudocodice](pseudocodice/cap09.txt) | [prompt](prompt/cap09.md) |
| 10 | Alberi binari di ricerca | [python](python/cap10.py) | [pseudocodice](pseudocodice/cap10.txt) | [prompt](prompt/cap10.md) |
| 11 | Alberi bilanciati: AVL e rosso-neri | [python](python/cap11.py) | [pseudocodice](pseudocodice/cap11.txt) | [prompt](prompt/cap11.md) |
| 12 | Heap e code con priorità | [python](python/cap12.py) | [pseudocodice](pseudocodice/cap12.txt) | [prompt](prompt/cap12.md) |
| 13 | Insiemi disgiunti, trie e alberi di Fenwick | [python](python/cap13.py) | [pseudocodice](pseudocodice/cap13.txt) | [prompt](prompt/cap13.md) |
| 14 | Ordinamenti elementari | [python](python/cap14.py) | [pseudocodice](pseudocodice/cap14.txt) | [prompt](prompt/cap14.md) |
| 15 | Merge sort e il paradigma divide et impera | [python](python/cap15.py) | [pseudocodice](pseudocodice/cap15.txt) | [prompt](prompt/cap15.md) |
| 16 | Quicksort | [python](python/cap16.py) | [pseudocodice](pseudocodice/cap16.txt) | [prompt](prompt/cap16.md) |
| 17 | Heapsort e limite inferiore dell’ordinamento per confronti | [python](python/cap17.py) | [pseudocodice](pseudocodice/cap17.txt) | [prompt](prompt/cap17.md) |
| 18 | Ordinamenti in tempo lineare: counting, radix, bucket | [python](python/cap18.py) | [pseudocodice](pseudocodice/cap18.txt) | [prompt](prompt/cap18.md) |
| 19 | Ricerca binaria e selezione | [python](python/cap19.py) | [pseudocodice](pseudocodice/cap19.txt) | [prompt](prompt/cap19.md) |
| 20 | Divide et impera oltre l’ordinamento | [python](python/cap20.py) | [pseudocodice](pseudocodice/cap20.txt) | [prompt](prompt/cap20.md) |
| 21 | Algoritmi golosi | [python](python/cap21.py) | [pseudocodice](pseudocodice/cap21.txt) | [prompt](prompt/cap21.md) |
| 22 | Programmazione dinamica: i principi | [python](python/cap22.py) | [pseudocodice](pseudocodice/cap22.txt) | [prompt](prompt/cap22.md) |
| 23 | Programmazione dinamica: problemi classici | [python](python/cap23.py) | [pseudocodice](pseudocodice/cap23.txt) | [prompt](prompt/cap23.md) |
| 24 | Backtracking e branch and bound | [python](python/cap24.py) | [pseudocodice](pseudocodice/cap24.txt) | [prompt](prompt/cap24.md) |
| 25 | Algoritmi probabilistici | [python](python/cap25.py) | [pseudocodice](pseudocodice/cap25.txt) | [prompt](prompt/cap25.md) |
| 26 | Rappresentazione e visite: BFS e DFS | [python](python/cap26.py) | [pseudocodice](pseudocodice/cap26.txt) | [prompt](prompt/cap26.md) |
| 27 | Ordinamento topologico e componenti connesse | [python](python/cap27.py) | [pseudocodice](pseudocodice/cap27.txt) | [prompt](prompt/cap27.md) |
| 28 | Alberi ricoprenti minimi: Kruskal e Prim | [python](python/cap28.py) | [pseudocodice](pseudocodice/cap28.txt) | [prompt](prompt/cap28.md) |
| 29 | Cammini minimi: Dijkstra, Bellman-Ford, Floyd-Warshall | [python](python/cap29.py) | [pseudocodice](pseudocodice/cap29.txt) | [prompt](prompt/cap29.md) |
| 30 | Flusso massimo e accoppiamenti | [python](python/cap30.py) | [pseudocodice](pseudocodice/cap30.txt) | [prompt](prompt/cap30.md) |
| 31 | Virgola mobile ed errori numerici | [python](python/cap31.py) | [pseudocodice](pseudocodice/cap31.txt) | [prompt](prompt/cap31.md) |
| 32 | Aritmetica degli interi | [python](python/cap32.py) | [pseudocodice](pseudocodice/cap32.txt) | [prompt](prompt/cap32.md) |
| 33 | Numeri primi e fattorizzazione | [python](python/cap33.py) | [pseudocodice](pseudocodice/cap33.txt) | [prompt](prompt/cap33.md) |
| 34 | Grandi numeri e polinomi | [python](python/cap34.py) | [pseudocodice](pseudocodice/cap34.txt) | [prompt](prompt/cap34.md) |
| 35 | Combinatoria e conteggio | [python](python/cap35.py) | [pseudocodice](pseudocodice/cap35.txt) | [prompt](prompt/cap35.md) |
| 36 | Ricerca degli zeri | [python](python/cap36.py) | [pseudocodice](pseudocodice/cap36.txt) | [prompt](prompt/cap36.md) |
| 37 | Sistemi lineari e matrici | [python](python/cap37.py) | [pseudocodice](pseudocodice/cap37.txt) | [prompt](prompt/cap37.md) |
| 38 | Derivazione e integrazione numerica | [python](python/cap38.py) | [pseudocodice](pseudocodice/cap38.txt) | [prompt](prompt/cap38.md) |
| 39 | Equazioni differenziali ordinarie | [python](python/cap39.py) | [pseudocodice](pseudocodice/cap39.txt) | [prompt](prompt/cap39.md) |
| 40 | Ottimizzazione | [python](python/cap40.py) | [pseudocodice](pseudocodice/cap40.txt) | [prompt](prompt/cap40.md) |
| 41 | Ricerca nelle stringhe | [python](python/cap41.py) | [pseudocodice](pseudocodice/cap41.txt) | [prompt](prompt/cap41.md) |
| 42 | Confronto approssimato: distanza di edit, sottosequenza comune, diff | [python](python/cap42.py) | [pseudocodice](pseudocodice/cap42.txt) | [prompt](prompt/cap42.md) |
| 43 | Analisi del testo: automi, tokenizzazione, shunting-yard | [python](python/cap43.py) | [pseudocodice](pseudocodice/cap43.txt) | [prompt](prompt/cap43.md) |
| 44 | Compressione: RLE, Huffman, LZ77 | [python](python/cap44.py) | [pseudocodice](pseudocodice/cap44.txt) | [prompt](prompt/cap44.md) |
| 45 | Hash, checksum e codifiche | [python](python/cap45.py) | [pseudocodice](pseudocodice/cap45.txt) | [prompt](prompt/cap45.md) |
| 46 | Manipolazione di bit | [python](python/cap46.py) | [pseudocodice](pseudocodice/cap46.txt) | [prompt](prompt/cap46.md) |
| 47 | Numeri casuali, mescolamento e campionamento | [python](python/cap47.py) | [pseudocodice](pseudocodice/cap47.txt) | [prompt](prompt/cap47.md) |
| 48 | Date e calendario | [python](python/cap48.py) | [pseudocodice](pseudocodice/cap48.txt) | [prompt](prompt/cap48.md) |
| 49 | Cache e strutture probabilistiche: LRU, filtro di Bloom | [python](python/cap49.py) | [pseudocodice](pseudocodice/cap49.txt) | [prompt](prompt/cap49.md) |
| 50 | Geometria computazionale | [python](python/cap50.py) | [pseudocodice](pseudocodice/cap50.txt) | [prompt](prompt/cap50.md) |
| 51 | NP-completezza | [python](python/cap51.py) | [pseudocodice](pseudocodice/cap51.txt) | [prompt](prompt/cap51.md) |
| 52 | Algoritmi di approssimazione | [python](python/cap52.py) | [pseudocodice](pseudocodice/cap52.txt) | [prompt](prompt/cap52.md) |
| 53 | Euristiche e metaeuristiche | [python](python/cap53.py) | [pseudocodice](pseudocodice/cap53.txt) | [prompt](prompt/cap53.md) |
| 54 | Algoritmi su flussi di dati | [python](python/cap54.py) | [pseudocodice](pseudocodice/cap54.txt) | [prompt](prompt/cap54.md) |
| 55 | Algoritmi paralleli | [python](python/cap55.py) | [pseudocodice](pseudocodice/cap55.txt) | [prompt](prompt/cap55.md) |

## Licenza

Il codice è distribuito con licenza MIT (file `LICENSE`). Il testo del libro è protetto da copyright e non fa parte del repository.

## Segnalazioni

Errori e suggerimenti si possono segnalare aprendo una *issue* in questo repository.
