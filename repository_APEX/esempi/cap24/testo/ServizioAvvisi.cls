public with sharing class ServizioAvvisi {

    public static void elabora(
            List<Avviso_Ordine__e> eventi) {
        List<Task> attivita = new List<Task>();
        for (Avviso_Ordine__e evento : eventi) {
            attivita.add(new Task(
                Subject = 'Ordine '
                    + evento.Codice_Ordine__c));
            EventBus.TriggerContext.currentContext()
                .setResumeCheckpoint(evento.ReplayId);
        }
        insert attivita;
    }
}
