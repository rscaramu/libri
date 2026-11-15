public with sharing class ControllerNuovoContatto {

    @AuraEnabled
    public static Id crea(Id azienda, String nome,
            String cognome, String posta) {
        if (String.isBlank(cognome)) {
            AuraHandledException e =
                new AuraHandledException('Cognome');
            e.setMessage('Il cognome e\' obbligatorio');
            throw e;
        }
        Contact c = new Contact(AccountId = azienda,
            FirstName = nome, LastName = cognome,
            Email = posta);
        insert as user c;
        return c.Id;
    }
}
