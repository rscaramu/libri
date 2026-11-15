public with sharing class GestoreContatti2
        extends GestoreTrigger {

    protected override void dopoInserimento(
            List<sObject> nuovi) {
        Set<Id> aziende = new Set<Id>();
        for (Contact c : (List<Contact>) nuovi) {
            if (c.AccountId != null) {
                aziende.add(c.AccountId);
            }
        }
        if (!aziende.isEmpty()) {
            Inoltro.riepilogo(aziende);
        }
    }
}
