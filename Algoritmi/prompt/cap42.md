# Capitolo 42 — Confronto approssimato: distanza di edit, sottosequenza comune, diff

## Prompt 1

Devo confrontare [descrizione: nomi di persone, righe di file, sequenze di simboli] tollerando [tipi di errore: refusi, scambi di lettere, parti mancanti]. Dimmi quale misura è adatta fra distanza di edit, Damerau-Levenshtein, Hamming, sottosequenza comune e misure normalizzate, come scegliere la soglia e quale libreria usare in [linguaggio].

## Prompt 2

Scrivi in [linguaggio] la distanza di edit con ricostruzione delle operazioni e la versione a due righe che restituisce soltanto il numero. Aggiungi un collaudo che verifichi su migliaia di coppie casuali: che le due versioni concordino, che la distanza sia simmetrica, che valga zero soltanto per stringhe uguali, e che applicando le operazioni alla prima stringa si ottenga la seconda.

## Prompt 3

Devo cercare in un dizionario di [numero] parole quelle a distanza di edit al più [k] da una parola data, in meno di [tempo]. Confronta: scansione con filtro sulla lunghezza, indice per gruppi di lettere, percorso del trie con potatura, albero BK. Indica costi di costruzione e di interrogazione.
