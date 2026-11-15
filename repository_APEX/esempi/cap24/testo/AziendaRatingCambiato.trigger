trigger AziendaRatingCambiato on AccountChangeEvent (
        after insert) {
    List<Task> attivita = new List<Task>();
    for (AccountChangeEvent evento : Trigger.new) {
        EventBus.ChangeEventHeader testata =
            evento.ChangeEventHeader;
        if (testata.getChangeType() != 'UPDATE'
                || !testata.getChangedFields()
                    .contains('Rating')) {
            continue;
        }
        for (String chiave : testata.getRecordIds()) {
            attivita.add(new Task(
                Subject = 'Valutazione cambiata: '
                    + evento.Rating,
                WhatId = chiave,
                OwnerId = testata.getCommitUser()));
        }
    }
    insert attivita;
}
