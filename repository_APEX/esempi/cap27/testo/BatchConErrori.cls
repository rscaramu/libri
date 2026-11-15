public with sharing class BatchConErrori
        implements Database.Batchable<sObject>,
            Database.Stateful {

    private List<String> errori = new List<String>();

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id, Name FROM Account
            WHERE BillingCountry = 'Italia']);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Account> lotto) {
        for (Account a : lotto) {
            a.Site = 'Sede principale';
        }
        List<Database.SaveResult> esiti =
            Database.update(lotto, false);
        for (Integer i = 0; i < esiti.size(); i++) {
            if (!esiti[i].isSuccess()
                    && errori.size() < 100) {
                errori.add(lotto[i].Name + ': '
                    + esiti[i].getErrors()[0]
                        .getMessage());
            }
        }
    }

    public void finish(
            Database.BatchableContext contesto) {
        System.debug('Errori: ' + errori.size());
    }
}
