public with sharing class LavoroAzienda
        implements Queueable {

    public void execute(QueueableContext contesto) {
        Account a = new Account(Name = 'Prova Catena',
            BillingCountry = 'Prova');
        insert a;
        System.enqueueJob(new LavoroContatto(a.Id));
    }
}
