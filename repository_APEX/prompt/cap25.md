# Capitolo 25 — I metodi future

Prompt del paragrafo «Con l’IA».

1. In questo gestore di trigger Apex c’è un’operazione lenta eseguita in modo sincrono: [incollate il gestore]. Dimmi se conviene spostarla in secondo piano, con quale strumento (future, Queueable, Batch) e quali conseguenze ha per l’utente il fatto che il risultato arrivi dopo.

2. Converti questo metodo Apex in un metodo @future: [incollate il metodo]. I parametri sObject devono diventare Set di Id, il metodo deve rileggere i record, gestire il caso in cui siano stati cancellati e registrare gli errori.

3. Scrivi una query SOQL su AsyncApexJob che mostri i lavori asincroni falliti nelle ultime 24 ore, con classe, metodo, messaggio di errore e utente che li ha avviati.
