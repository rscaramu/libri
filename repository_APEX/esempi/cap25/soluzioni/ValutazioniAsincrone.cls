public with sharing class ValutazioniAsincrone {

    @future
    public static void raffredda(Set<Id> aziende) {
        List<Account> daScrivere = [
            SELECT Id FROM Account
            WHERE Id IN :aziende
            AND Id NOT IN (SELECT AccountId
                FROM Opportunity
                WHERE IsClosed = false)];
        for (Account a : daScrivere) {
            a.Rating = 'Cold';
        }
        update daScrivere;
    }
}
