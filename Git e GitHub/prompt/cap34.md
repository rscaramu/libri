# Capitolo 34 — Progetto completo: dall’idea alla release

## Prompt 1 — Il primo giorno di un progetto.

```text
Sto avviando un progetto [linguaggio] su GitHub, da
solo per ora ma con collaboratori in futuro. Elenca in
ordine tutti i file e le impostazioni da creare il
primo giorno (gitignore, attributes, CI, Dependabot,
ruleset, licenza, CONTRIBUTING), con il contenuto
minimo di ciascuno e i comandi git e gh per farlo.
```

## Prompt 2 — Ripercorrere una modifica.

```text
Ecco la storia della mia PR dal ramo alla release:
[incollate git log --oneline main..ramo, la
descrizione della PR e i commenti della revisione]
Valuta il flusso: i commit sono ben divisi? Il
messaggio finale dello squash e' informativo? Che
cosa avrei potuto fare meglio nella PR e nella
risposta alla revisione?
```

## Prompt 3 — Automatizzare la release.

```text
Il mio progetto Python usa Conventional Commits, main
protetto senza bypass, e rilascio manuale con tag.
Sostituisci il passaggio manuale con release-please:
scrivi il workflow, spiega la PR di release che apre,
come si fonde con la protezione del ramo e come
collegarlo alla pubblicazione su PyPI.
```

## I limiti

Un progetto reale ha vincoli che nessun esempio cattura: dipendenze legacy, clienti con versioni bloccate, colleghi con abitudini diverse. Usate il flusso di questo capitolo come scheletro e l’IA per adattarne i pezzi, non per sostituire il giudizio su che cosa serve davvero al vostro team.
