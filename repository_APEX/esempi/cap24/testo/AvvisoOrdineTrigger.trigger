trigger AvvisoOrdineTrigger on Avviso_Ordine__e (
        after insert) {
    List<Task> attivita = new List<Task>();
    for (Avviso_Ordine__e evento : Trigger.new) {
        if (evento.Urgente__c) {
            attivita.add(new Task(
                Subject = 'Ordine urgente '
                    + evento.Codice_Ordine__c,
                Priority = 'High',
                OwnerId = evento.CreatedById));
        }
    }
    insert attivita;
}
