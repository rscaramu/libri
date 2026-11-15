trigger TrattativaAttivita on Opportunity (after insert) {
    List<Task> attivita = new List<Task>();
    for (Opportunity o : Trigger.new) {
        if (o.Amount != null && o.Amount >= 100000) {
            attivita.add(new Task(
                Subject = 'Verifica trattativa rilevante',
                WhatId = o.Id,
                OwnerId = o.OwnerId,
                ActivityDate = Date.today().addDays(3)));
        }
    }
    insert attivita;
}
