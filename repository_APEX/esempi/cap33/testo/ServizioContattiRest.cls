@RestResource(urlMapping='/v1/contatti')
global with sharing class ServizioContattiRest {

    global class Esito {
        global Boolean riuscito;
        global String id;
        global String errore;
    }

    @HttpPost
    global static Esito crea(String nome,
            String cognome, String posta, String azienda) {
        Esito esito = new Esito();
        if (String.isBlank(cognome)) {
            RestContext.response.statusCode = 400;
            esito.riuscito = false;
            esito.errore = 'Il cognome e\' obbligatorio';
            return esito;
        }
        try {
            Contact c = new Contact(FirstName = nome,
                LastName = cognome, Email = posta,
                AccountId = azienda);
            insert as user c;
            RestContext.response.statusCode = 201;
            esito.riuscito = true;
            esito.id = c.Id;
        } catch (DmlException e) {
            RestContext.response.statusCode = 422;
            esito.riuscito = false;
            esito.errore = e.getDmlMessage(0);
        }
        return esito;
    }
}
