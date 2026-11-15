trigger ScortaBassaTrigger on Scorta_Bassa__e (
        after insert) {
    List<Task> attivita = new List<Task>();
    for (Scorta_Bassa__e evento : Trigger.new) {
        if (evento.Quantita__c < 10) {
            attivita.add(new Task(
                Subject = 'Riordinare '
                    + evento.Codice__c,
                OwnerId = evento.CreatedById));
        }
    }
    insert attivita;
}
