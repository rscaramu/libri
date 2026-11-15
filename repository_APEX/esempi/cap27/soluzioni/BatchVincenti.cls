public with sharing class BatchVincenti
        implements Database.Batchable<sObject>,
            Database.Stateful {

    private Integer conVinte = 0;
    private Integer senza = 0;

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id, (SELECT Id FROM Opportunities
                WHERE IsWon = true LIMIT 1)
            FROM Account
            WHERE BillingCountry = 'Italia']);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Account> lotto) {
        for (Account a : lotto) {
            if (a.Opportunities.isEmpty()) {
                senza++;
            } else {
                conVinte++;
            }
        }
    }

    public void finish(
            Database.BatchableContext contesto) {
        System.debug('Con vinte: ' + conVinte
            + ', senza: ' + senza);
    }
}
