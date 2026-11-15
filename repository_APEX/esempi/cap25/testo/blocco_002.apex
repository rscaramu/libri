Set<Id> chiavi = new Map<Id, Account>([
    SELECT Id FROM Account
    WHERE BillingCountry = 'Italia']).keySet();
RiepilogoAsincrono.aggiorna(chiavi);
System.debug('Richiesta inoltrata');
System.debug(Limits.getFutureCalls());
