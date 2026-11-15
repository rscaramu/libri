# Capitolo 32 — Chiamate a servizi esterni

Prompt del paragrafo «Con l’IA».

1. Questa è la documentazione di un’API REST: [incollate la descrizione dell’endpoint, con un esempio di richiesta e di risposta]. Scrivi una classe Apex che la chiami tramite una Named Credential, con classi per richiesta e risposta, controllo del codice di stato, eccezione personalizzata e nessuna credenziale nel codice.

2. Scrivi i test Apex per questa classe che esegue callout: [incollate la classe]. Usa un HttpCalloutMock configurabile e copri risposta corretta, 404, 500, corpo JSON malformato e tempo scaduto simulato con una CalloutException.

3. Questo trigger Apex deve notificare un sistema esterno a ogni Opportunity vinta: [incollate il gestore]. Proponi la struttura con un Queueable che esegue il callout, lavora in blocco, riprova con attesa crescente sugli errori 5xx e registra i fallimenti definitivi.
