trigger CasoOsservatore on Case (
        before insert, after insert,
        before update, after update) {
    for (Case c : Trigger.new) {
        System.debug(Trigger.operationType + ' - Status: '
            + c.Status);
    }
}
