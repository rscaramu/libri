public with sharing class ContattiAzienda {

    public static List<Contact> elenco(Id azienda) {
        if (azienda == null) {
            return new List<Contact>();
        }
        return [
            SELECT FirstName, LastName, Title, Email
            FROM Contact
            WHERE AccountId = :azienda
            WITH USER_MODE
            ORDER BY LastName
        ];
    }
}
