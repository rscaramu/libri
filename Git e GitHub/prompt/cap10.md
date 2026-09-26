# Capitolo 10 — Stash, cherry-pick e tag

## Prompt 1 — Interruzione del lavoro.

```text
Sto lavorando su un ramo con modifiche non finite in
tre file e un file nuovo non tracciato. Devo passare
urgentemente su main per correggere un errore e poi
tornare esattamente dove ero. Dammi la sequenza di
comandi con git stash, includendo il file nuovo, e
spiega come verificare di non aver perso nulla.
```

## Prompt 2 — Portare una correzione su due versioni.

```text
Ho corretto un errore con un commit sul ramo develop.
Devo portare la stessa correzione sui rami release/1.4
e release/1.5, che sono molto diversi da develop.
Spiega come usare git cherry-pick -x, che cosa fare in
caso di conflitto e perche' non conviene fare merge.
```

## Prompt 3 — Strategia dei tag.

```text
Proponi una convenzione di versionamento per una
libreria con rilasci mensili e correzioni occasionali,
basata su semantic versioning e tag annotati. Includi
i comandi per creare un tag, elencarli ordinati per
versione e generare un numero di versione automatico
con git describe.
```

## I limiti

Un cherry-pick può applicarsi senza conflitti e produrre comunque codice sbagliato, se il commit dipendeva da modifiche precedenti che non avete copiato. L’IA non può saperlo dal solo diff: dopo il cherry-pick, provate il risultato.
