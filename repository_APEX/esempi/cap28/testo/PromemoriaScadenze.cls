public with sharing class PromemoriaScadenze
        implements Schedulable {

    public void execute(SchedulableContext contesto) {
        List<Task> attivita = new List<Task>();
        for (Opportunity o : [
                SELECT Id, Name, OwnerId
                FROM Opportunity
                WHERE IsClosed = false
                AND CloseDate = NEXT_N_DAYS:7]) {
            attivita.add(new Task(
                Subject = 'In scadenza: ' + o.Name,
                WhatId = o.Id, OwnerId = o.OwnerId,
                ActivityDate = Date.today()));
        }
        insert attivita;
    }
}
