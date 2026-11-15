# Capitolo 27 — Batch Apex

Prompt del paragrafo «Con l’IA».

1. Scrivi una classe Batch Apex che imposti il campo Rating a Cold sugli Account senza Opportunity negli ultimi 12 mesi. Usa Database.Stateful per contare record aggiornati ed errori, salvataggio parziale in execute e un riepilogo per posta in finish. Indica la dimensione del lotto che consigli e perché.

2. Questo batch Apex supera il limite di tempo del processore in execute: [incollate la classe]. Analizza le cause possibili, comprese quelle esterne al codice come trigger e flussi sugli oggetti aggiornati, e proponi le correzioni in ordine di efficacia.

3. Devo elaborare ogni notte circa 5.000 record con una chiamata a un servizio esterno per ciascuno. Confronta Batch Apex con lotti piccoli e una catena di Queueable: limiti, tempi, gestione degli errori. Quale sceglieresti?
