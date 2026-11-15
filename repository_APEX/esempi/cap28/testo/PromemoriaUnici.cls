public with sharing class PromemoriaUnici
        implements Schedulable {

    public void execute(SchedulableContext contesto) {
        Map<Id, Opportunity> inScadenza =
            new Map<Id, Opportunity>([
                SELECT Id, Name, OwnerId
                FROM Opportunity
                WHERE IsClosed = false
                AND CloseDate = NEXT_N_DAYS:7]);
        Set<Id> giaAvvisate = new Set<Id>();
        for (Task t : [SELECT WhatId FROM Task
                WHERE WhatId IN :inScadenza.keySet()
                AND Subject LIKE 'In scadenza:%'
                AND ActivityDate = TODAY]) {
            giaAvvisate.add(t.WhatId);
        }
        List<Task> attivita = new List<Task>();
        for (Opportunity o : inScadenza.values()) {
            if (!giaAvvisate.contains(o.Id)) {
                attivita.add(new Task(
                    Subject = 'In scadenza: ' + o.Name,
                    WhatId = o.Id, OwnerId = o.OwnerId,
                    ActivityDate = Date.today()));
            }
        }
        insert attivita;
    }
}
