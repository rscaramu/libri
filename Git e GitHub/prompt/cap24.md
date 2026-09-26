# Capitolo 24 — GitHub CLI

## Prompt 1 — Comporre un comando.

```text
Con gh, voglio elencare le pull request aperte del
repository corrente che aspettano una mia revisione da
piu' di due giorni, mostrando numero, titolo, autore e
data, ordinate dalla piu' vecchia. Scrivi il comando
con --json e --jq.
```

## Prompt 2 — Uno script di automazione.

```text
Scrivi uno script bash che, per ogni repository
dell'organizzazione "acme" (gh repo list), copi le
etichette dal repository acme/modello con gh label
clone, saltando quelli archiviati e stampando un
riepilogo. Deve poter essere rieseguito senza danni.
```

## Prompt 3 — Dall’API.

```text
Non trovo un comando gh per ottenere il numero di
download di ogni asset di tutte le release del
repository. Mostrami come farlo con "gh api" (endpoint,
paginazione con --paginate) e come sommare i totali
con --jq.
```

## I limiti

Le opzioni di `gh` cambiano tra versioni: se un comando suggerito non esiste, `gh <comando> --help` è la verità. Gli script generati che modificano molti repository vanno provati prima su uno solo, con `echo` al posto dei comandi distruttivi.
