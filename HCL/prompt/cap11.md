# Capitolo 11 — Funzioni per collezioni

## Prompt 1

Ti incollo un valore HCL di partenza e il valore che voglio ottenere. Scrivimi la trasformazione come sequenza di valori locali, uno per passaggio, usando funzioni predefinite ed espressioni `for`. Per ogni locale indica il valore intermedio atteso, così che io possa verificarlo nella console.

## Prompt 2

Spiegami dall’interno verso l’esterno che cosa fa questa espressione: `sort(distinct(flatten([for u in var.utenti : u.gruppi])))`. Poi dimmi se cambierebbe qualcosa sostituendo `sort(distinct(…))` con `tolist(toset(…))`.

## Prompt 3

Devo fondere una mappa di impostazioni predefinite con una di impostazioni dell’utente, e alcune voci sono a loro volta oggetti. Mostrami perché `merge` da solo non basta e scrivi la fusione corretta su due livelli, senza funzioni inesistenti.
