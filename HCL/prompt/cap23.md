# Capitolo 23 — Ristrutturare: moved, import, removed

## Prompt 1

Ti incollo l’uscita di `tofu state list` prima della ristrutturazione e la nuova struttura del codice, in cui queste risorse sono passate da `count` a `for_each` e sono state spostate in un modulo. Scrivimi tutti i blocchi `moved` necessari, uno per istanza, e dimmi come verificare con il piano che non ne manchi nessuno.

## Prompt 2

Questo file è stato prodotto da `-generate-config-out` importando risorse esistenti. Ripuliscilo: togli gli argomenti che valgono `null` o il valore predefinito, sostituisci con riferimenti gli identificativi che corrispondono ad altre risorse presenti nel file, e proponi quali valori trasformare in variabili. Elencami ogni modifica, così che io possa controllare che il piano resti senza cambiamenti.

## Prompt 3

Devo trasferire tre risorse dalla configurazione A alla configurazione B senza ricrearle. Scrivimi la procedura in ordine, con i blocchi da aggiungere in ciascuna, i controlli da fare dopo ogni passo e che cosa fare se a metà qualcosa va storto.
