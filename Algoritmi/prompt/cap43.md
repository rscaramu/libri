# Capitolo 43 — Analisi del testo: automi, tokenizzazione, shunting-yard

## Prompt 1

Devo analizzare testi con questa struttura: [descrizione ed esempi validi e non validi]. Prima scrivi la grammatica in forma di regole, senza ricorsione a sinistra, indicando precedenza e associatività degli operatori. Poi scrivi in [linguaggio] il tokenizzatore e l’analizzatore ricorsivo discendente, con una funzione per regola e messaggi d’errore che riportino la posizione.

## Prompt 2

Questa espressione regolare viene applicata a testo fornito dagli utenti: [espressione]. Verifica se è esposta al ritorno all’indietro catastrofico, mostrando un ingresso che la mette in crisi. Proponi una riscrittura equivalente che non lo sia, o un’alternativa senza espressioni regolari.

## Prompt 3

Scrivi un insieme di prove per il mio valutatore di espressioni: [codice]. Includi precedenze, associatività a sinistra e a destra, meno unario in tutte le posizioni, parentesi annidate, spazi anomali, e una lista di ingressi non validi per ciascuno dei quali va verificato che l’errore sia segnalato alla posizione giusta.
