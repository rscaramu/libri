public with sharing class BatchConteggio
        implements Database.Batchable<sObject>,
            Database.Stateful {

    private Integer lotti = 0;
    private Integer record = 0;

    public Database.QueryLocator start(
            Database.BatchableContext contesto) {
        return Database.getQueryLocator([
            SELECT Id FROM Contact
            WHERE MailingCountry = 'Italia']);
    }

    public void execute(
            Database.BatchableContext contesto,
            List<Contact> lotto) {
        lotti++;
        record += lotto.size();
    }

    public void finish(
            Database.BatchableContext contesto) {
        System.debug(record + ' record in '
            + lotti + ' lotti');
    }
}
