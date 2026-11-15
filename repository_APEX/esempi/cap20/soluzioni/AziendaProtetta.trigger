trigger AziendaProtetta on Account (before delete) {
    for (Account a : Trigger.old) {
        if (a.Description != null
                && a.Description.contains('PROTETTA')) {
            a.addError('Azienda protetta');
        }
    }
}
