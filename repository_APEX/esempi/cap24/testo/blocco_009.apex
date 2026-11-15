List<Avviso_Ordine__e> eventi =
    new List<Avviso_Ordine__e>();
for (Integer i = 1; i <= 3; i++) {
    eventi.add(new Avviso_Ordine__e(
        Codice_Ordine__c = 'ORD-PROVA-' + i,
        Importo__c = 100 * i,
        Urgente__c = i == 3));
}
Integer riusciti = 0;
for (Database.SaveResult esito
        : EventBus.publish(eventi)) {
    if (esito.isSuccess()) {
        riusciti++;
    }
}
System.debug(riusciti);
System.debug(Limits.getDmlStatements());
