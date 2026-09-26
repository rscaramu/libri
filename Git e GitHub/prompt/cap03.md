# Capitolo 3 — Il primo repository

## Prompt 1 — Messaggi di commit.

```text
Ecco il diff delle modifiche che sto per registrare:
[incollate l'output di "git diff --staged"]
Proponi un messaggio di commit in italiano con titolo
di massimo 50 caratteri all'indicativo presente e un
corpo di 2-4 righe che spieghi il perche' della modifica.
```

## Prompt 2 — Interpretare lo stato.

```text
Questo e' l'output di "git status -s" nel mio repository:
[incollate l'output]
Spiegami riga per riga il significato delle due colonne
di stato e dimmi quali comandi devo eseguire per
registrare tutto in un unico commit, esclusi i file
non tracciati.
```

## Prompt 3 — Dividere un commit.

```text
Ho modificato cinque file per due motivi diversi:
tre riguardano una nuova funzione, due correggono un
errore. Come faccio a creare due commit separati?
Spiegami anche come usare "git add -p" per dividere
le modifiche all'interno dello stesso file.
```

## I limiti

Un messaggio di commit generato dall’IA descrive ciò che vede nel diff, non ciò che avevate in mente: il *perché* lo sapete solo voi. Usate il suggerimento come bozza e correggete la motivazione. Non incollate mai diff contenenti segreti o dati personali in un servizio esterno.
