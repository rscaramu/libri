public with sharing class LavoroRicontattoSicuro
        implements Queueable, Finalizer {

    private Set<Id> trattative;

    public LavoroRicontattoSicuro(Set<Id> trattative) {
        this.trattative = trattative;
    }

    public void execute(QueueableContext contesto) {
        System.attachFinalizer(this);
        new LavoroRicontatto(trattative).execute(contesto);
    }

    public void execute(FinalizerContext contesto) {
        if (contesto.getResult()
                == ParentJobResult.SUCCESS) {
            System.debug('Riuscito');
        } else {
            System.debug(LoggingLevel.ERROR,
                contesto.getException().getMessage());
        }
    }
}
