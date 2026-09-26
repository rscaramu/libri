# Capitolo 13 — Gli oggetti

## Prompt 1 — Ricostruire il grafo.

```text
Ecco l'output di "git cat-file -p" per un commit, per
il suo tree e per un blob:
[incollate i tre output]
Spiega come sono collegati, disegna il grafo degli
oggetti e indica che cosa cambierebbe (e che cosa no)
se modificassi una riga del file.
```

## Prompt 2 — Un commit senza porcelain.

```text
Guidami passo per passo nella creazione di un commit
usando solo comandi di plumbing: hash-object,
update-index, write-tree, commit-tree e update-ref.
Per ogni comando spiega quale oggetto crea e dove
finisce.
```

## Prompt 3 — Deduplicazione.

```text
Il mio repository ha 500 commit e 2000 file, ma
"git count-objects -v" riporta molti meno oggetti di
quanti mi aspetterei. Spiega perche', con riferimento
a come Git memorizza blob e tree, e come posso
stimare lo spazio davvero occupato dalla storia.
```

## I limiti

L’IA ricostruisce correttamente il modello degli oggetti, ma i dettagli numerici (dimensioni, numero di oggetti) vanno letti dal vostro repository: non fidatevi di stime. Diffidate anche di proposte che toccano `.git/objects` direttamente.
