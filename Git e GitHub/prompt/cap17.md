# Capitolo 17 — Submodule, subtree, worktree e LFS

## Prompt 1 — Scegliere tra submodule e subtree.

```text
Il mio progetto usa una libreria interna sviluppata da
un altro team, aggiornata ogni settimana, che a volte
dobbiamo correggere noi in attesa che loro integrino.
Confronta submodule, subtree e pubblicazione della
libreria come pacchetto, con i comandi del flusso
quotidiano per ciascuna opzione, e consiglia.
```

## Prompt 2 — Diagnosi di un submodule.

```text
Dopo "git pull" il mio submodule esterni/lib risulta
modificato in "git status" ma non ho toccato nulla.
Ecco "git diff --submodule" e "git submodule status":
[incollate gli output]
Spiega che cosa e' successo e come allinearlo.
```

## Prompt 3 — Migrare a LFS.

```text
Il mio repository ha 400 MB di file .png e .mp4 nella
storia. Voglio passare a Git LFS. Elenca i passi con
"git lfs migrate", le conseguenze per i collaboratori
(riscrittura della storia), i limiti di GitHub e come
verificare il risparmio di spazio prima e dopo.
```

## I limiti

Le raccomandazioni sull’architettura delle dipendenze dipendono da fattori che l’IA non vede (quanto spesso cambia la libreria, chi la mantiene, quali strumenti di *build* usate): trattatele come un elenco di opzioni. Per LFS, i limiti di quota cambiano nel tempo: verificate sulla documentazione di GitHub.
