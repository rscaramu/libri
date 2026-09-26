# Capitolo 7 — I rami

## Prompt 1 — Leggere un grafico.

```text
Ecco l'output di "git log --oneline --all --graph":
[incollate l'output]
Descrivi a parole la struttura della storia: quanti
rami ci sono, da quale commit divergono, quali
contengono lavoro non presente in main. Poi disegnala
come diagramma ASCII semplificato con i soli nomi dei
rami.
```

## Prompt 2 — Commit sul ramo sbagliato.

```text
Ho fatto due commit su main che dovevano andare su un
nuovo ramo "ricerca". Non ho ancora condiviso nulla.
Dammi la sequenza esatta di comandi per spostarli su
"ricerca" e riportare main dov'era, spiegando ogni
passo e come verificare il risultato.
```

## Prompt 3 — Strategia dei rami.

```text
Lavoro da solo a un'applicazione con rilasci mensili.
Proponi una convenzione semplice per i nomi dei rami e
una regola per quando creare un ramo e quando lavorare
direttamente su main. Motiva ogni scelta.
```

## I limiti

L’IA legge un grafico ASCII con qualche difficoltà quando la storia è complessa: aiutatela con `--decorate` e con un elenco dei rami da `git branch -v`. Le strategie di ramificazione che propone sono ragionevoli ma generiche; quelle adatte al vostro team dipendono da dimensione, ritmo di rilascio e strumenti, temi del capitolo 23.
