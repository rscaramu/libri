Database.SaveResult esito = EventBus.publish(
    new Scorta_Bassa__e(Codice__c = 'V-10',
        Quantita__c = 4));
System.debug(esito.isSuccess());
