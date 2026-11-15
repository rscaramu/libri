public with sharing class LavoroACursore
        implements Queueable {

    private Database.Cursor cursore;
    private Integer posizione;

    public LavoroACursore() {
        cursore = Database.getCursor(
            'SELECT Id FROM Contact'
            + ' WHERE MailingCountry = \'Italia\'');
        posizione = 0;
    }

    public void execute(QueueableContext contesto) {
        List<Contact> tratto =
            cursore.fetch(posizione, 200);
        for (Contact c : tratto) {
            c.Description = 'Letto dal cursore';
        }
        update tratto;
        posizione += tratto.size();
        if (posizione < cursore.getNumRecords()) {
            System.enqueueJob(this);
        }
    }
}
