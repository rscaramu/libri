public with sharing class BatchConAvviso
        implements Database.Batchable<sObject> {

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id, Rating FROM Account
            WHERE BillingCountry = 'Italia'
            AND Rating = null]);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Account> lotto) {
        for (Account a : lotto) {
            a.Rating = 'Cold';
        }
        Database.update(lotto, false);
    }

    public void finish(
            Database.BatchableContext contesto) {
        AsyncApexJob esito = [
            SELECT TotalJobItems, NumberOfErrors
            FROM AsyncApexJob
            WHERE Id = :contesto.getJobId()];
        Messaging.SingleEmailMessage posta =
            new Messaging.SingleEmailMessage();
        posta.setTargetObjectId(UserInfo.getUserId());
        posta.setSaveAsActivity(false);
        posta.setSubject('Valutazioni aggiornate');
        posta.setPlainTextBody('Lotti: '
            + esito.TotalJobItems + ', falliti: '
            + esito.NumberOfErrors);
        Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{
                posta });
    }
}
