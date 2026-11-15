# Capitolo 18 — Transazioni, limiti ed elaborazione in blocco

Prompt del paragrafo «Con l’IA».

1. Rivedi questa classe Apex cercando violazioni dei governor limits: query o DML dentro cicli, anche nascoste in metodi chiamati dal ciclo; cicli annidati su liste; query senza filtri selettivi: [incollate la classe]. Per ogni problema indica riga, rischio e correzione.

2. Riscrivi questo metodo Apex secondo lo schema raccogli, leggi, indicizza, elabora e scrivi: [incollate il metodo]. Voglio una sola query e una sola istruzione DML qualunque sia il numero di record. Commenta i quattro passaggi.

3. Aggiungi a questo metodo Apex alcune righe di System.debug che usano la classe Limits per mostrare quante query, quante istruzioni DML e quanto tempo di processore consuma: [incollate il metodo].
