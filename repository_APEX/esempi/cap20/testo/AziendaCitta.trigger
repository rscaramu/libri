trigger AziendaCitta on Account (after update) {
    Map<Id, String> nuoveCitta = new Map<Id, String>();
    for (Account a : Trigger.new) {
        Account prima = Trigger.oldMap.get(a.Id);
        if (a.BillingCity != prima.BillingCity) {
            nuoveCitta.put(a.Id, a.BillingCity);
        }
    }
    if (nuoveCitta.isEmpty()) {
        return;
    }
    List<Contact> persone = [
        SELECT Id, AccountId FROM Contact
        WHERE AccountId IN :nuoveCitta.keySet()];
    for (Contact c : persone) {
        c.MailingCity = nuoveCitta.get(c.AccountId);
    }
    update persone;
}
