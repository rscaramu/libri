public with sharing class Parametri2 {

    public static Decimal numero(
            String nome, Decimal predefinito) {
        Parametro__mdt p = Parametro__mdt.getInstance(nome);
        if (p == null || !p.Attivo__c
                || p.Numero__c == null) {
            return predefinito;
        }
        return p.Numero__c;
    }

    public static Boolean attivo(String nome) {
        Parametro__mdt p = Parametro__mdt.getInstance(nome);
        return p == null || p.Attivo__c;
    }
}
