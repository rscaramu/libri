# Capitolo 10 — Funzioni per stringhe e numeri

## Prompt 1

Scrivimi un’espressione regolare in sintassi RE2, da usare con la funzione `regex` di Terraform/OpenTofu, che da un nome nel formato `progetto-ambiente-NN` estragga progetto, ambiente e numero come gruppi con nome. Scrivi la stringa già con le barre rovesciate raddoppiate per HCL e dammi tre casi di prova, uno dei quali non deve corrispondere.

## Prompt 2

Mi serve una convalida HCL per una variabile che deve contenere un nome di host valido: solo minuscole, cifre e trattini, inizio con una lettera, lunghezza massima 63. Scrivi il blocco `validation` e spiegami perché è preferibile `can(regex(…))` a `regex(…)` da solo.

## Prompt 3

Elencami le funzioni HCL per le stringhe il cui ordine degli argomenti è controintuitivo, indicando per ciascuna la firma e un esempio, così che io possa farne un promemoria.
