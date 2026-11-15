public with sharing class LavoroRicontatto
        implements Queueable {

    private Set<Id> trattative;

    public LavoroRicontatto(Set<Id> trattative) {
        this.trattative = trattative;
    }

    public void execute(QueueableContext contesto) {
        List<Opportunity> aperte = [
            SELECT Id FROM Opportunity
            WHERE Id IN :trattative
            AND IsClosed = false];
        for (Opportunity o : aperte) {
            o.NextStep = 'Ricontattare';
        }
        update aperte;
    }
}
