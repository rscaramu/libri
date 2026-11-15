public with sharing class BatchRiepilogoContatti
        implements Database.Batchable<sObject> {

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator(
            'SELECT Id FROM Account'
            + ' WHERE BillingCountry = \'Italia\'');
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Account> lotto) {
        Riepilogo.aggiorna(lotto);
    }

    public void finish(
            Database.BatchableContext contesto) {
        System.debug('Elaborazione terminata');
    }
}
