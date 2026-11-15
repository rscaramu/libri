# Capitolo 15 — Dipendenze e grafo di esecuzione

## Prompt 1

Ti incollo una configurazione HCL completa. Elencami le dipendenze fra le risorse, distinguendo quelle implicite, con l’espressione che le genera, da quelle dichiarate con `depends_on`. Poi indica l’ordine di creazione e quali risorse possono essere create in parallelo.

## Prompt 2

Ottengo l’errore «Cycle» con questi indirizzi. Ti incollo i blocchi coinvolti. Spiegami il percorso del ciclo, riferimento per riferimento, e proponimi una ristrutturazione che lo elimini senza usare `depends_on`.

## Prompt 3

In questa configurazione ci sono cinque `depends_on`. Per ciascuno dimmi se è ridondante perché esiste già un riferimento implicito, se si può sostituire con un riferimento, o se è davvero necessario; in quest’ultimo caso scrivi il commento che lo giustifica.
