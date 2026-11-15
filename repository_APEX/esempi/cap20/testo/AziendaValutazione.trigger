trigger AziendaValutazione on Account (after update) {
    List<Task> attivita = new List<Task>();
    for (Account a : Trigger.new) {
        Account prima = Trigger.oldMap.get(a.Id);
        if (a.Rating == 'Hot' && prima.Rating != 'Hot') {
            attivita.add(new Task(
                Subject = 'Contattare cliente promettente',
                WhatId = a.Id, OwnerId = a.OwnerId));
        }
    }
    insert attivita;
}
