# Capitolo 9 — Rebase

## Prompt 1 — Merge o rebase in un caso concreto.

```text
Il mio ramo "pagamenti" ha 8 commit ed e' partito da
main tre settimane fa; nel frattempo main ha ricevuto
40 commit di altre persone. Non ho ancora condiviso
"pagamenti". Devo fare merge o rebase? Spiega che cosa
succede alla storia nei due casi, quale approccio mi
fara' risolvere meno conflitti e in quale ordine.
```

## Prompt 2 — Interpretare un conflitto in rebase.

```text
Durante "git rebase main" ho questo conflitto:
[incollate il file con i marcatori]
Ricordami quale sezione e' la mia modifica e quale
quella di main (so che in rebase e' invertito), poi
proponi una risoluzione e i comandi per proseguire.
```

## Prompt 3 — --onto.

```text
Ho tre rami impilati: main <- infra <- api <- ui.
Ho appena integrato infra in main. Scrivi i comandi
"git rebase --onto" per riportare api e ui sopra main
senza duplicare i commit di infra, e spiega i tre
argomenti di --onto per ciascun comando.
```

## I limiti

L’IA non sa se i vostri commit sono già stati condivisi: diteglielo esplicitamente, perché è l’informazione che decide tra merge e rebase. Non eseguite un `rebase` suggerito senza prima verificare con `git log --oneline --all --graph` che il ramo e la base siano quelli che intendete.
