public with sharing class EtichetteAsincrone {

    @future
    public static void applica(Set<Id> trattative) {
        List<Opportunity> attuali = [
            SELECT Id, AccountId FROM Opportunity
            WHERE Id IN :trattative];
        Etichette.applica(attuali);
    }
}
