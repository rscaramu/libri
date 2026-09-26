# Capitolo 33 — Disastri, backup e manutenzione

## Prompt 1 — Guida al recupero.

```text
Ho eseguito per errore "git reset --hard" seguito da
"git clean -fd" sul mio ramo di lavoro. Avevo fatto
"git add" su alcuni file un'ora fa ma nessun commit da
ieri. Ecco "git reflog" e "git fsck --lost-found":
[incollate gli output]
Che cosa posso recuperare e come, e che cosa e' perso
definitivamente? Non propormi comandi che eliminano
oggetti.
```

## Prompt 2 — Repository corrotto.

```text
"git status" risponde "fatal: bad object HEAD" e
"git fsck" stampa:
[incollate l'output]
Ho un remoto su GitHub aggiornato a ieri e modifiche
locali non registrate in tre file. Guidami nel
recupero passo per passo, iniziando con il backup
della cartella .git.
```

## Prompt 3 — Strategia di backup.

```text
Progetta una strategia di backup per i 20 repository
della mia organizzazione GitHub: mirror automatico su
un secondo servizio, bundle settimanali su storage
oggetti, esportazione delle issue e PR, con un workflow
di Actions e uno script, e una procedura di prova del
ripristino trimestrale.
```

## I limiti

Nel recupero conta l’ordine dei comandi, e un comando sbagliato può essere l’ultimo: leggete ogni suggerimento dell’IA chiedendovi «questo può eliminare oggetti?» e, se sì, non eseguitelo prima di aver copiato `.git`. L’IA non vede il vostro disco: incollate `reflog` e `fsck` completi.
