# Capitolo 14 — Riferimenti, HEAD e packfile

## Prompt 1 — Diagnosi di spazio.

```text
Il mio repository occupa 2 GB su disco ma i file
attuali pesano 50 MB. Ecco l'output di
"git count-objects -v" e i primi venti oggetti di
"git verify-pack -v" ordinati per dimensione:
[incollate gli output]
Spiega che cosa occupa spazio, come risalire ai file
responsabili e quali comandi usare per ridurlo.
```

## Prompt 2 — Recupero senza reflog.

```text
Ho cancellato un ramo con -D e il reflog e' scaduto.
Spiegami come usare "git fsck --dangling" e
"git cat-file" per ritrovare i commit e ricreare il
ramo, con i comandi esatti e i limiti del metodo.
```

## Prompt 3 — HEAD e riferimenti.

```text
Spiega la differenza tra HEAD, ORIG_HEAD, FETCH_HEAD
e MERGE_HEAD, quando ciascuno esiste e un caso in cui
usare ORIG_HEAD mi salverebbe da un errore.
```

## I limiti

Le stime di spazio dell’IA sono ragionamenti, non misure: i numeri veri vengono da `count-objects` e `verify-pack`. Prima di eseguire un `gc --prune=now` suggerito, ricordate che elimina la rete di sicurezza.
