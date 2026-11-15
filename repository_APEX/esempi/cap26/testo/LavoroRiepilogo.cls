public with sharing class LavoroRiepilogo
        implements Queueable {

    private Set<Id> aziende;

    public LavoroRiepilogo(Set<Id> aziende) {
        this.aziende = aziende;
    }

    public void execute(QueueableContext contesto) {
        Riepilogo.aggiorna([SELECT Id FROM Account
            WHERE Id IN :aziende]);
    }
}
