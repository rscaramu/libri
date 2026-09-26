# Capitolo 4 — Le tre aree

## Prompt 1 — Spiegare un diff.

```text
Ecco un diff in formato unified:
[incollate l'output di "git diff"]
Spiegami blocco per blocco che cosa e' cambiato, in
linguaggio naturale, e segnala eventuali modifiche che
sembrano accidentali (spazi, righe vuote, indentazione).
```

## Prompt 2 — Pianificare i commit.

```text
Ho fatto molte modifiche in un unico file senza fare
commit. Ecco il diff completo:
[incollate "git diff"]
Raggruppa le modifiche in commit logicamente separati,
proponi per ciascuno un messaggio e dimmi in che ordine
rispondere alle domande di "git add -p" per ottenerli.
```

## Prompt 3 — Le tre aree.

```text
Spiegami la differenza tra directory di lavoro, indice
e repository in Git usando l'analogia di una cucina di
ristorante. Poi dimmi quale delle tre aree viene
modificata da ciascuno di questi comandi: git add,
git commit, git restore, git restore --staged,
git diff, git diff --staged.
```

## I limiti

L’IA può suggerire come raggruppare le modifiche, ma non sa quali di esse siano logicamente collegate nel vostro progetto: due righe cambiate in file diversi possono essere la stessa correzione o due correzioni indipendenti, e solo voi lo sapete.
