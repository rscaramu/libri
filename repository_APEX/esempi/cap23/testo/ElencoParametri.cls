public with sharing class ElencoParametri {

    public static Map<String, Decimal> numerici() {
        Map<String, Decimal> esito =
            new Map<String, Decimal>();
        for (Parametro__mdt p
                : Parametro__mdt.getAll().values()) {
            if (p.Attivo__c && p.Numero__c != null) {
                esito.put(p.DeveloperName, p.Numero__c);
            }
        }
        return esito;
    }
}
