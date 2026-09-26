# Capitolo 31 — Repository grandi e monorepo

## Prompt 1 — Diagnosi delle prestazioni.

```text
"git status" nel mio repository impiega 8 secondi.
Ecco "git count-objects -vH", "git ls-files | wc -l",
"git rev-list --count --all", la versione di Git e il
sistema operativo, e l'output di
"GIT_TRACE_PERFORMANCE=1 git status":
[incollate]
Individua la causa e proponi le impostazioni o le
operazioni per ridurre il tempo, in ordine di impatto.
```

## Prompt 2 — Script di clone per il team.

```text
Il nostro monorepo ha 40 GB di storia e cartelle
apps/*, libs/*, tools/*. Scrivi uno script bash che
faccia clone parziale senza blob, sparse checkout in
modalita' cone delle cartelle passate come argomenti
piu' tools/, attivi fsmonitor e untrackedCache, e
avvii la manutenzione automatica. Deve funzionare su
macOS e Linux.
```

## Prompt 3 — Monorepo o no.

```text
Abbiamo 6 servizi in 6 repository con una libreria
condivisa pubblicata come pacchetto interno; ogni
modifica alla libreria richiede 6 PR di aggiornamento
e le versioni divergono. Stiamo valutando un monorepo.
Elenca benefici e costi per il nostro caso, i passi di
una migrazione che conservi la storia (git subtree o
filter-repo) e le regole di CI per non ricompilare
tutto a ogni PR.
```

## I limiti

Le impostazioni di prestazione dipendono dalla versione di Git e dal sistema operativo: `fsmonitor`, per esempio, ha comportamenti diversi su Linux. Verificate con misure prima e dopo. La scelta monorepo/polyrepo è organizzativa prima che tecnica; l’IA elenca i fattori, la decisione è vostra.
