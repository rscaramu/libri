# Capitolo 26 — Queueable Apex

Prompt del paragrafo «Con l’IA».

1. Converti questo metodo @future in una classe Queueable Apex: [incollate il metodo]. Passa i dati dal costruttore, restituisci l’Id del lavoro a chi lo avvia e aggiungi un Finalizer che registri l’eventuale eccezione non gestita.

2. Scrivi una classe Queueable Apex che elabori una lista di Id a porzioni di 200, riaccodando sé stessa finché restano elementi, con una profondità massima impostata tramite AsyncOptions. Spiega che cosa accade se la lista ha 10.000 elementi.

3. Spiegami con un esempio la differenza fra gestire gli errori di un Queueable con try/catch e con un Transaction Finalizer, e in quale caso solo il secondo funziona.
