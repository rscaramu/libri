trigger ContattoModifiche on ContactChangeEvent (
        after insert) {
    for (ContactChangeEvent evento : Trigger.new) {
        EventBus.ChangeEventHeader testata =
            evento.ChangeEventHeader;
        System.debug(testata.getChangeType() + ' - '
            + testata.getRecordIds() + ' - '
            + testata.getChangedFields());
    }
}
