public with sharing class LavoroMarcatura
        implements Queueable {

    private static final Integer PORZIONE = 200;
    private List<Id> daTrattare;

    public LavoroMarcatura(List<Id> daTrattare) {
        this.daTrattare = daTrattare;
    }

    public void execute(QueueableContext contesto) {
        List<Contact> daScrivere = new List<Contact>();
        List<Id> resto = new List<Id>();
        for (Integer i = 0; i < daTrattare.size(); i++) {
            if (i < PORZIONE) {
                daScrivere.add(new Contact(
                    Id = daTrattare[i],
                    Description = 'Marcato'));
            } else {
                resto.add(daTrattare[i]);
            }
        }
        Database.update(daScrivere, false);
        if (!resto.isEmpty()) {
            System.enqueueJob(new LavoroMarcatura(resto));
        }
    }
}
