public with sharing class GestoreTrattative2
        extends GestoreTrigger {

    protected override void dopoModifica(
            List<sObject> nuovi, Map<Id, sObject> vecchi) {
        List<Opportunity> vinte = new List<Opportunity>();
        for (Opportunity o : (List<Opportunity>) nuovi) {
            Opportunity prima =
                (Opportunity) vecchi.get(o.Id);
            if (o.StageName == 'Closed Won'
                    && prima.StageName != 'Closed Won') {
                vinte.add(o);
            }
        }
        if (!vinte.isEmpty()) {
            ServizioRingraziamenti.crea(vinte);
        }
    }
}
