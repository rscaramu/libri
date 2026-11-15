public with sharing class InserimentoProtetto {

    public static Set<String> aziende(
            List<Account> ricevute) {
        SObjectAccessDecision decisione =
            Security.stripInaccessible(
                AccessType.CREATABLE, ricevute);
        insert decisione.getRecords();
        Set<String> scartati = decisione
            .getRemovedFields().get('Account');
        return scartati ?? new Set<String>();
    }
}
