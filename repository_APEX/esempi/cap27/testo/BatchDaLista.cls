public with sharing class BatchDaLista
        implements Database.Batchable<String> {

    private List<String> nomi;

    public BatchDaLista(List<String> nomi) {
        this.nomi = nomi;
    }

    public Iterable<String> start(
            Database.BatchableContext contesto) {
        return nomi;
    }

    public void execute(
            Database.BatchableContext contesto,
            List<String> lotto) {
        List<Lead> nuovi = new List<Lead>();
        for (String nome : lotto) {
            nuovi.add(new Lead(LastName = nome,
                Company = 'Da qualificare'));
        }
        insert nuovi;
    }

    public void finish(
            Database.BatchableContext contesto) {
    }
}
