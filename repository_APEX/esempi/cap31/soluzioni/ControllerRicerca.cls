public with sharing class ControllerRicerca {

    @AuraEnabled(cacheable=true)
    public static List<Account> perNome(String testo) {
        if (String.isBlank(testo)) {
            return new List<Account>();
        }
        String modello = '%' + testo.trim() + '%';
        return [
            SELECT Id, Name, BillingCity FROM Account
            WHERE BillingCountry = 'Italia'
                AND Name LIKE :modello
            WITH USER_MODE
            ORDER BY Name
            LIMIT 20
        ];
    }
}
