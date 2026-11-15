public with sharing class ControllerContatti {

    @AuraEnabled(cacheable=true)
    public static List<Contact> diAzienda(Id azienda) {
        if (azienda == null) {
            return new List<Contact>();
        }
        return [
            SELECT Id, FirstName, LastName, Title, Email
            FROM Contact
            WHERE AccountId = :azienda
            WITH USER_MODE
            ORDER BY LastName
            LIMIT 200
        ];
    }
}
