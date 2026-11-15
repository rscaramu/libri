public with sharing class GestoreAziende
        extends GestoreTrigger {

    protected override void dopoModifica(
            List<sObject> nuovi, Map<Id, sObject> vecchi) {
        List<Account> promosse = new List<Account>();
        for (Account a : (List<Account>) nuovi) {
            Account prima = (Account) vecchi.get(a.Id);
            if (a.Rating == 'Hot'
                    && prima.Rating != 'Hot') {
                promosse.add(a);
            }
        }
        if (!promosse.isEmpty()) {
            ServizioAziende.avvisaTitolari(promosse);
        }
    }
}
