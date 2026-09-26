# Capitolo 27 — Actions avanzate

## Prompt 1 — Pipeline completa.

```text
Progetta un workflow con tre job: test in matrice
(Ubuntu e Windows, Node 18 e 20), build che produce
un artefatto solo se i test passano, e deploy su
un ambiente "produzione" solo per i push su main, con
concurrency per annullare le esecuzioni superate.
Scrivi il YAML completo con commenti.
```

## Prompt 2 — Da dieci copie a un workflow riutilizzabile.

```text
Ho lo stesso workflow di test copiato in dieci
repository Python, con piccole differenze nella
versione di Python e nel comando di test. Aiutami a
trasformarlo in un workflow riutilizzabile con input,
e mostrami come lo richiamerebbe ciascun repository.
Come gestisco il versionamento del workflow centrale?
```

## Prompt 3 — Un’azione composite.

```text
Scrivi un'azione composite che riceva in input un
percorso e una dimensione massima in KB, verifichi che
nessun file sotto quel percorso superi il limite, e
in caso contrario fallisca elencando i file. Deve
esporre come output il numero di file controllati.
```

## I limiti

I workflow complessi hanno molte interazioni (permessi, ambienti, cache, matrici) che l’IA non può provare; iterate su un repository di prova e leggete i registri. Per i runner propri, la sicurezza dipende dalla vostra infrastruttura: i consigli generici non bastano.
