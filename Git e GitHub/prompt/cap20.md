# Capitolo 20 — Push, fetch e pull

## Prompt 1 — Interpretare un rifiuto.

```text
"git push" mi risponde:
[incollate l'output]
e "git status" dice:
[incollate l'output]
Spiegami che cosa e' successo tra il mio repository e
il server, e dammi la sequenza per integrare le novita'
mantenendo la storia lineare, con i punti in cui
potrei incontrare conflitti.
```

## Prompt 2 — Force o non force.

```text
Ho fatto un rebase interattivo sul ramo feature/login
che avevo gia' inviato su GitHub ieri; nessun altro ci
lavora. "git push" viene rifiutato. Spiegami la
differenza tra --force e --force-with-lease, quale
usare qui e come verificare prima che nessuno abbia
inviato commit sul ramo.
```

## Prompt 3 — Configurazione per il team.

```text
Il nostro team di cinque persone fa pull con merge e
la storia di main e' piena di commit "Merge branch
'main' of ...". Proponi una configurazione condivisa
(pull.rebase, push.default, fetch.prune) e una breve
guida per i colleghi con il flusso quotidiano.
```

## I limiti

L’IA propone `--force` con facilità perché risolve il sintomo. Prima di ogni push forzato suggerito, chiedete se il ramo è condiviso e usate `--force-with-lease`. Sui conflitti che il pull può produrre, l’IA non vede i file: incollateli.
