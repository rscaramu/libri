# Capitolo 16 — Hooks

## Prompt 1 — Scrivere un hook.

```text
Scrivi un hook pre-commit in shell POSIX che, per ogni
file .py in staging, esegua "ruff check" e "ruff format
--check", stampi gli errori e blocchi il commit se ne
trova. Deve funzionare anche se nessun file .py e' in
staging e non deve toccare file non in staging.
```

## Prompt 2 — Rilevare segreti.

```text
Proponi un hook pre-commit che cerchi nei file in
staging modelli tipici di credenziali (chiavi AWS,
token GitHub, chiavi private PEM, stringhe "password="
con valore) e blocchi il commit, con un elenco di
espressioni regolari commentate e un modo per
escludere falsi positivi.
```

## Prompt 3 — Strategia di condivisione.

```text
Il mio team di sei persone usa Python e vuole che
tutti eseguano gli stessi controlli prima del commit.
Confronta core.hooksPath con una cartella versionata,
il framework pre-commit e l'applicazione delle regole
sul server con GitHub Actions. Consiglia una
combinazione e i passi per adottarla.
```

## I limiti

Un hook generato dall’IA va provato su casi limite (nessun file in staging, nomi di file con spazi, file cancellati) prima di distribuirlo: un hook che fallisce con un errore di shell blocca tutti i commit di tutti. E ricordate che nessun hook locale sostituisce le protezioni lato server.
