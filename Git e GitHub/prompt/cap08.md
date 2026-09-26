# Capitolo 8 — Merge e conflitti

## Prompt 1 — Capire un conflitto.

```text
Ecco un file con un conflitto di merge in stile diff3:
[incollate il file, con i marcatori]
Spiegami che cosa ha cambiato ciascun ramo rispetto
alla base, proponi una risoluzione che conservi
l'intento di entrambi e mostrami il file finale senza
marcatori.
```

## Prompt 2 — Scegliere tra fast-forward, no-ff e squash.

```text
Il mio team discute se integrare i rami con merge
fast-forward, con --no-ff o con --squash. Spiega i tre
approcci con un esempio di storia risultante per
ciascuno (in ASCII) e indica pregi e difetti in termini
di leggibilita' della storia e di facilita' di
annullamento.
```

## Prompt 3 — Conflitti ricorrenti.

```text
Nel mio progetto ogni merge produce conflitti nello
stesso file (un changelog o un file di traduzioni).
Quali strategie esistono per ridurli? Parlami di
merge.conflictStyle, di git rerere e delle convenzioni
di scrittura del file che evitano il problema.
```

## I limiti

L’IA può proporre una risoluzione sensata sul piano testuale, ma non sa se le due modifiche fossero semanticamente compatibili: due rami possono unirsi senza conflitto e produrre un programma sbagliato. Dopo ogni merge, compilate ed eseguite i test; l’assenza di conflitti non è una prova di correttezza.
