public with sharing class GestoreAziendeProtette
        extends GestoreTrigger {

    protected override void primaCancellazione(
            List<sObject> vecchi) {
        Map<Id, sObject> perId =
            new Map<Id, sObject>(vecchi);
        Set<Id> conVinte = new Set<Id>();
        for (AggregateResult r : [
                SELECT AccountId az FROM Opportunity
                WHERE AccountId IN :perId.keySet()
                AND IsWon = true
                GROUP BY AccountId]) {
            conVinte.add((Id) r.get('az'));
        }
        for (Id chiave : conVinte) {
            perId.get(chiave).addError(
                'Azienda con trattative vinte');
        }
    }
}
