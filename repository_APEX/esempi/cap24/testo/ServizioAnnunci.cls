public with sharing class ServizioAnnunci {

    public static void trattativeVinte(
            List<Opportunity> vinte) {
        List<Avviso_Ordine__e> eventi =
            new List<Avviso_Ordine__e>();
        for (Opportunity o : vinte) {
            eventi.add(new Avviso_Ordine__e(
                Codice_Ordine__c =
                    String.valueOf(o.Id),
                Importo__c = o.Amount,
                Urgente__c = false));
        }
        if (!eventi.isEmpty()) {
            EventBus.publish(eventi);
        }
    }
}
