# Capitolo 26 — GitHub Actions: i fondamenti

## Prompt 1 — Il primo workflow.

```text
Il mio progetto e' un'applicazione Node.js 20 con
"npm ci", "npm run lint" e "npm test". Scrivi un
workflow GitHub Actions che giri su ogni PR e su main,
usi la cache di npm, esegua lint e test in due job
separati e pubblichi il rapporto di copertura come
artefatto. Commenta ogni sezione.
```

## Prompt 2 — Diagnosi di un fallimento.

```text
Il mio workflow fallisce nello step "Esegui i test"
con questo registro:
[incollate l'output di "gh run view --log-failed"]
Ecco il workflow:
[incollate il file]
Spiega la causa piu' probabile e la correzione, e dimmi
come verificarla senza fare dieci push di prova.
```

## Prompt 3 — Eventi e filtri.

```text
Voglio che i test completi girino solo su main e sulle
PR verso main, che una versione ridotta giri su ogni
altro ramo, che nulla giri se cambiano solo file .md,
e che ogni domenica alle 3 giri una suite lenta.
Scrivi la sezione "on:" e la struttura dei job con le
condizioni "if" necessarie.
```

## I limiti

L’IA scrive YAML plausibile ma non può eseguirlo: una versione di azione inesistente (`actions/setup-python@v9`) o un’opzione rinominata si scoprono solo alla prima esecuzione. Verificate le versioni sul Marketplace, e non copiate mai in un prompt il contenuto dei segreti.
