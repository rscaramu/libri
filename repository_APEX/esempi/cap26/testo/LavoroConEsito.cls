public with sharing class LavoroConEsito
        implements Queueable, Finalizer {

    private List<Id> contatti;

    public LavoroConEsito(List<Id> contatti) {
        this.contatti = contatti;
    }

    public void execute(QueueableContext contesto) {
        System.attachFinalizer(this);
        List<Contact> daScrivere = new List<Contact>();
        for (Id chiave : contatti) {
            daScrivere.add(new Contact(Id = chiave,
                Description = 'Con esito'));
        }
        update daScrivere;
    }

    public void execute(FinalizerContext contesto) {
        if (contesto.getResult()
                == ParentJobResult.SUCCESS) {
            System.debug('Lavoro riuscito');
            return;
        }
        Diario.errore('LavoroConEsito',
            contesto.getException());
    }
}
