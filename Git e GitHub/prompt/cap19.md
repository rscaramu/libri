# Capitolo 19 — GitHub e i repository remoti

## Prompt 1 — Diagnosi di connessione.

```text
"git push" fallisce con questo output:
[incollate l'output completo, compreso l'eventuale
messaggio di ssh o di autenticazione]
Il remoto e' [URL]. Elenca le cause possibili in
ordine di probabilita' e i comandi per verificare
ciascuna (ssh -T, git remote -v, gh auth status).
```

## Prompt 2 — Scegliere la licenza.

```text
Voglio pubblicare su GitHub una libreria che spero
venga usata anche in prodotti commerciali, ma vorrei
che chi la migliora condivida le modifiche. Confronta
MIT, Apache 2.0, LGPL e GPL rispetto a questi due
obiettivi e consiglia, spiegando le conseguenze
pratiche per chi usera' la libreria.
```

## Prompt 3 — Impostare il repository.

```text
Sto per creare su GitHub il repository di un progetto
Python open source. Elenca i file da mettere nella
radice e in .github/ (README, LICENSE, CONTRIBUTING,
CODE_OF_CONDUCT, modelli di issue, .gitignore), con
un modello per ciascuno e l'ordine in cui crearli.
```

## I limiti

L’IA non può verificare lo stato del vostro account né provare la connessione: gli output di `ssh -T`, `git remote -v` e `gh auth status` sono le informazioni che le servono. Sulle licenze fornisce un orientamento, non un parere legale.
