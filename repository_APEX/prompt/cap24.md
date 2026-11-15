# Capitolo 24 — Eventi di piattaforma e Change Data Capture

Prompt del paragrafo «Con l’IA».

1. Devo notificare a tre sistemi esterni ogni ordine confermato in Salesforce. Confronta tre soluzioni: chiamate dirette da Apex, platform event personalizzato, Change Data Capture. Per ciascuna indica vantaggi, rischi, limiti da verificare e quando la sceglieresti.

2. Scrivi un trigger Apex su un platform event Errore_Applicazione__e che salvi ogni evento in un oggetto personalizzato Registro_Errore__c. Deve lavorare in blocco, usare setResumeCheckpoint e sollevare RetryableException in caso di errore di blocco dei record, con un massimo di tre tentativi.

3. Spiegami la differenza fra Publish After Commit e Publish Immediately nei platform event di Salesforce, con un esempio concreto in cui la scelta sbagliata provoca un errore di funzionamento.
