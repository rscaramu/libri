# Capitolo 16 — SOSL e interrogazioni dinamiche

Prompt del paragrafo «Con l’IA».

1. Esamina questo metodo Apex che usa Database.query con concatenazione di stringhe: [incollate il metodo]. Individua ogni punto in cui è possibile un’iniezione di SOQL, spiega come potrebbe essere sfruttato e riscrivilo con queryWithBinds e un elenco di valori ammessi per i nomi di campo.

2. Scrivi una classe Apex che costruisca una query dinamica su Contact con filtri facoltativi su cognome (inizia con), città e data di creazione minima. I filtri assenti non devono comparire. Usa variabili di collegamento per tutti i valori.

3. Devo permettere a un utente di cercare una parola fra Account, Contact e Lead. Mi conviene SOSL o tre query SOQL con LIKE? Confronta le due soluzioni per limiti, prestazioni e risultati, e scrivi quella che consigli.
