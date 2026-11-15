public with sharing class LavoroCopia
        implements Queueable {

    private List<Account> originali;

    public LavoroCopia(List<Account> originali) {
        this.originali = originali;
    }

    public void execute(QueueableContext contesto) {
        List<Account> copie = new List<Account>();
        for (Account a : originali) {
            copie.add(new Account(
                Name = a.Name + ' (copia)',
                Industry = a.Industry,
                BillingCountry = 'Prova'));
        }
        insert copie;
    }
}
