# Capitolo 25 — Protezione dei rami, CODEOWNERS e permessi

## Prompt 1 — Progettare le regole.

```text
Il mio repository e' una libreria open source con 3
manutentori e molti contributori esterni via fork.
Proponi la configurazione dei ruleset per main e per i
tag, un CODEOWNERS iniziale e le impostazioni del
pulsante di merge, spiegando ogni scelta e i rischi di
una configurazione troppo rigida.
```

## Prompt 2 — CODEOWNERS da una struttura.

```text
Ecco la struttura delle cartelle del mio monorepo
(output di "tree -L 2") e i team dell'organizzazione
con le loro competenze:
[incollate le informazioni]
Scrivi il file CODEOWNERS, con i proprietari
predefiniti, le eccezioni per cartella e le regole per
i file di configurazione della piattaforma.
```

## Prompt 3 — Diagnosi di una PR bloccata.

```text
La mia PR mostra "Merging is blocked" con questi
messaggi:
[incollate i messaggi della sezione di merge]
Spiega quale regola blocca, chi puo' sbloccarla e
che cosa devo fare io come autore.
```

## I limiti

Le impostazioni di GitHub cambiano nome e posizione nel tempo, e l’IA può descrivere una schermata vecchia: la documentazione ufficiale (docs.github.com) è la fonte aggiornata. E le regole di protezione riflettono decisioni organizzative (chi approva, chi rilascia) che l’assistente non può prendere per voi.
