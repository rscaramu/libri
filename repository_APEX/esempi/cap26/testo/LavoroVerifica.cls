public with sharing class LavoroVerifica
        implements Queueable, Database.AllowsCallouts {

    private Id azienda;

    public LavoroVerifica(Id azienda) {
        this.azienda = azienda;
    }

    public void execute(QueueableContext contesto) {
        // Qui la chiamata al servizio esterno,
        // argomento del Capitolo 32.
        update new Account(Id = azienda,
            Description = 'Verificata');
    }
}
