Avviso_Ordine__e evento = new Avviso_Ordine__e(
    Codice_Ordine__c = 'ORD-2026-00417',
    Importo__c = 1850,
    Urgente__c = true);
Database.SaveResult esito = EventBus.publish(evento);
System.debug(esito.isSuccess());
System.debug(Limits.getDmlStatements());
