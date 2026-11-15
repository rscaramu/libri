public with sharing class BatchPaeseContatti
        implements Database.Batchable<sObject> {

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id FROM Contact
            WHERE MailingCountry = null
            AND Account.BillingCountry = 'Italia']);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Contact> lotto) {
        for (Contact c : lotto) {
            c.MailingCountry = 'Italia';
        }
        Database.update(lotto, false);
    }

    public void finish(
            Database.BatchableContext contesto) {
    }
}
