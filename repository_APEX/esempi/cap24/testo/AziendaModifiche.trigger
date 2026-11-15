trigger AziendaModifiche on AccountChangeEvent (
        after insert) {
    for (AccountChangeEvent evento : Trigger.new) {
        EventBus.ChangeEventHeader testata =
            evento.ChangeEventHeader;
        System.debug(testata.getChangeType() + ' su '
            + testata.getRecordIds());
        if (testata.getChangeType() == 'UPDATE') {
            System.debug('Campi: '
                + testata.getChangedFields());
        }
    }
}
