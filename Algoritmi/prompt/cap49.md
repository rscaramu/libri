# Capitolo 49 — Cache e strutture probabilistiche: LRU, filtro di Bloom

## Prompt 1

Nel mio sistema [descrizione: che cosa è lento, quanto spesso cambia, quante richieste, quanti elementi distinti] voglio introdurre una cache. Proponi: che cosa conservare, con quale chiave, quale capacità e politica di sostituzione, come e quando invalidare, che cosa accade se il dato è vecchio, e quali metriche misurare per sapere se la cache sta servendo.

## Prompt 2

Scrivi in [linguaggio] una cache LRU con tabella hash e lista doppia con sentinella, con lettura e scrittura in tempo costante. Aggiungi un collaudo che confronti il comportamento, operazione per operazione, con una versione ingenua basata su una lista ordinata per ultimo uso, su migliaia di operazioni casuali con poche chiavi.

## Prompt 3

Devo verificare l’appartenenza a un insieme di [numero] elementi con al più [percentuale] di falsi positivi. Calcola bit totali e numero di funzioni hash di un filtro di Bloom, la memoria in megabyte, e che cosa accade al tasso d’errore se gli elementi diventano il doppio. Dimmi se nel mio caso servono le cancellazioni e quale variante usare.
