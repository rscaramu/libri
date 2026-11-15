public with sharing class BatchPrimo
        implements Database.Batchable<sObject> {

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id FROM Account
            WHERE BillingCountry = 'Italia']);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Account> lotto) {
        Riepilogo.aggiorna(lotto);
    }

    public void finish(
            Database.BatchableContext contesto) {
        Database.executeBatch(new BatchRevisione());
    }
}
