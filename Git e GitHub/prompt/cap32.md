# Capitolo 32 — Migrazione e interoperabilità

## Prompt 1 — Piano di migrazione.

```text
Devo migrare 30 repository da un GitLab aziendale a
un'organizzazione GitHub, conservando rami, tag, LFS e
possibilmente issue e merge request. Scrivi un piano
in fasi, con i comandi per la parte Git, gli strumenti
per la parte non-Git, come fare la prova su un
repository, e come gestire la finestra di congelamento.
```

## Prompt 2 — Da SVN.

```text
Ho un repository Subversion con layout standard, 12
anni di storia, 40 autori e molti tag. Guidami nella
conversione con git svn: preparazione del file autori,
comando di clone, conversione dei tag in tag annotati,
pulizia dei rami remoti, rimozione delle righe
git-svn-id e verifica del risultato.
```

## Prompt 3 — Estrarre una libreria.

```text
Voglio estrarre la cartella packages/ui del mio
monorepo in un repository separato con la sua storia,
e poi reinserirla nel monorepo come submodule. Elenca
i comandi con git filter-repo, i controlli per
verificare che la storia sia completa, e i rischi
per chi ha rami aperti che toccano quella cartella.
```

## I limiti

Le migrazioni sono operazioni irreversibili su dati preziosi: qualunque procedura suggerita va provata su una copia e verificata contando commit, rami e tag prima e dopo (`git rev-list --count --all`, `git for-each-ref | wc -l`). Gli strumenti per la parte non-Git (issue, PR) cambiano rapidamente: verificate che esistano ancora.
