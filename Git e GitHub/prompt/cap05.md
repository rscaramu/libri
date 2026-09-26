# Capitolo 5 — Leggere la storia

## Prompt 1 — Costruire la domanda giusta.

```text
Voglio sapere quali commit dell'ultimo trimestre, fatti
da un autore la cui email termina con @azienda.example,
hanno toccato la cartella src/pagamenti/ e contengono
nel messaggio la parola "rimborso". Scrivimi il comando
git log completo, con output in una riga per commit
che mostri hash, data breve e titolo.
```

## Prompt 2 — Riassumere la storia.

```text
Ecco l'output di "git log --oneline --reverse" di un
progetto:
[incollate l'output]
Raggruppa i commit in fasi di sviluppo, dai un titolo a
ciascuna fase e segnala i commit il cui messaggio e'
troppo vago per capire che cosa e' stato fatto.
```

## Prompt 3 — Trovare quando è cambiato qualcosa.

```text
In un file di configurazione, il valore di "timeout"
era 30 e ora e' 5, ma non so quando e' cambiato. Quali
comandi git log uso per trovare il commit responsabile
e vedere il diff? Spiega la differenza tra -S e -G.
```

## I limiti

Per riassumere una storia, l’IA ha bisogno dei messaggi di commit: se sono vaghi, il riassunto sarà vago. Incollare centinaia di righe di `log -p` in un assistente può superare i limiti di contesto e, se il repository è privato, esporre codice che non dovrebbe uscire: filtrate prima.
