# Capitolo 54 — Algoritmi su flussi di dati

## Prompt 1

Devo rispondere a queste domande su un flusso di [descrizione: quanti eventi al secondo, quanti elementi distinti attesi]: [elenco delle domande]. Per ciascuna indica la struttura adatta, i parametri necessari per un errore di [percentuale], la memoria richiesta, il verso dell’errore, e se la struttura è già disponibile in [Redis / la mia base di dati / una libreria in linguaggio].

## Prompt 2

Scrivi in [linguaggio] uno schizzo Count-Min e un HyperLogLog con una funzione hash stabile fra esecuzioni. Aggiungi un collaudo che li confronti con conteggi esatti su un flusso sintetico con distribuzione molto sbilanciata, e che misuri l’errore osservato rispetto a quello teorico al variare dei parametri.

## Prompt 3

Devo calcolare [media, deviazione standard, percentili, massimo] sugli ultimi [intervallo] di un flusso, aggiornando il risultato a ogni arrivo. Proponi le strutture per farlo in tempo costante o logaritmico per elemento, indicando la memoria e che cosa accade quando gli elementi arrivano fuori ordine.
