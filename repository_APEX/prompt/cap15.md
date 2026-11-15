# Capitolo 15 — SOQL: relazioni e aggregazioni

Prompt del paragrafo «Con l’IA».

1. In Salesforce ho l’oggetto personalizzato Intervento__c con il campo di ricerca Cliente__c verso Account; il nome della relazione figlia è Interventi. Scrivi due query SOQL: una che dagli interventi legga il nome del cliente, una che dagli Account legga gli interventi dell’ultimo mese. Spiega dove si usa __c e dove __r.

2. Scrivi una query SOQL aggregata che restituisca, per ogni titolare (Owner.Name) di Opportunity, il numero di trattative vinte e l’importo totale nell’anno corrente, solo per chi supera i 100.000 euro. Poi mostrami il ciclo Apex che legge gli AggregateResult.

3. Questo codice Apex calcola totali con un ciclo su tutti i record: [incollate il codice]. Riscrivilo con una query aggregata e dimmi quante righe del limite si risparmiano con 10.000 record.
