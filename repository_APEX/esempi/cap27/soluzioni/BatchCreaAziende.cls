public with sharing class BatchCreaAziende
        implements Database.Batchable<String> {

    private List<String> nomi;

    public BatchCreaAziende(List<String> nomi) {
        this.nomi = nomi;
    }

    public Iterable<String> start(
            Database.BatchableContext contesto) {
        return nomi;
    }

    public void execute(
            Database.BatchableContext contesto,
            List<String> lotto) {
        List<Account> nuove = new List<Account>();
        for (String nome : lotto) {
            nuove.add(new Account(Name = nome,
                BillingCountry = 'Prova'));
        }
        Database.insert(nuove, false);
    }

    public void finish(
            Database.BatchableContext contesto) {
    }
}
