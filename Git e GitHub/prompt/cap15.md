# Capitolo 15 — Bisect, blame e ricerca nella storia

## Prompt 1 — Scrivere lo script per bisect.

```text
Il mio progetto Node.js ha un test che fallisce con
"npm test -- --grep 'calcolo IVA'". Scrivi uno script
per "git bisect run" che installi le dipendenze se
package.json e' cambiato, esegua solo quel test e
restituisca 125 se il progetto non compila.
```

## Prompt 2 — Interpretare il commit trovato.

```text
git bisect ha individuato questo commit come primo
difettoso; ecco "git show" completo:
[incollate l'output]
Il sintomo e' [descrizione]. Indica quale modifica nel
diff e' la causa piu' probabile e perche', e proponi
una correzione minima.
```

## Prompt 3 — Archeologia di una riga.

```text
Voglio sapere perche' una certa riga di codice esiste.
Ho l'output di "git blame -w -M -C" e il messaggio del
commit indicato, ma il messaggio dice solo "fix".
Quali altri comandi git posso usare per ricostruire il
contesto (log -L, log -S, la pull request associata)?
Elencali in ordine di utilita'.
```

## I limiti

L’IA può aiutare a scrivere lo script di test e a leggere il diff del commit trovato, ma la bisezione richiede un test deterministico che solo voi potete garantire, e il giudizio su «che cosa si è rotto» dipende dalla conoscenza del programma. Non date per acquisita una diagnosi dell’IA senza riprodurre il difetto e verificarne la correzione.
