trigger TrattativaAumento on Opportunity (after update) {
    List<Task> attivita = new List<Task>();
    for (Opportunity o : Trigger.new) {
        Decimal prima = Trigger.oldMap.get(o.Id).Amount;
        if (prima != null && prima > 0
                && o.Amount != null
                && o.Amount > prima * 1.5) {
            attivita.add(new Task(
                Subject = 'Verificare aumento importo',
                WhatId = o.Id, OwnerId = o.OwnerId));
        }
    }
    insert attivita;
}
