public with sharing class LavoroContatto
        implements Queueable {

    private Id azienda;

    public LavoroContatto(Id azienda) {
        this.azienda = azienda;
    }

    public void execute(QueueableContext contesto) {
        insert new Contact(LastName = 'Concatenato',
            AccountId = azienda);
    }
}
