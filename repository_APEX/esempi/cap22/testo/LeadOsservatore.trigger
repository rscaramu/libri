trigger LeadOsservatore on Lead (
        before insert, after insert,
        before update, after update) {
    System.debug(Trigger.operationType + ' - Rating: '
        + ((Lead) Trigger.new[0]).Rating);
}
