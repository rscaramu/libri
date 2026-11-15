trigger AziendaPrimoContatto on Account (after insert) {
    List<Task> attivita = new List<Task>();
    for (Account a : Trigger.new) {
        if (a.Rating == 'Hot') {
            attivita.add(new Task(
                Subject = 'Primo contatto',
                WhatId = a.Id, OwnerId = a.OwnerId,
                ActivityDate = Date.today().addDays(2)));
        }
    }
    insert attivita;
}
