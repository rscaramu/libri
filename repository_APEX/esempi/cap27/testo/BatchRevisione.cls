public with sharing class BatchRevisione
        implements Database.Batchable<sObject> {

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id FROM Opportunity
            WHERE IsClosed = false
            AND Account.BillingCountry = 'Italia']);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Opportunity> lotto) {
        for (Opportunity o : lotto) {
            o.Description = 'Da rivedere';
        }
        Database.update(lotto, false);
    }

    public void finish(
            Database.BatchableContext contesto) {
    }
}
