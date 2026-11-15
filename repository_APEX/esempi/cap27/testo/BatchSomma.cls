public with sharing class BatchSomma
        implements Database.Batchable<sObject>,
            Database.Stateful {

    private Decimal totale = 0;

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Amount FROM Opportunity
            WHERE Account.BillingCountry = 'Italia']);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Opportunity> lotto) {
        for (Opportunity o : lotto) {
            totale += o.Amount ?? 0;
        }
    }

    public void finish(
            Database.BatchableContext contesto) {
        System.debug('Totale: ' + totale.setScale(0));
    }
}
