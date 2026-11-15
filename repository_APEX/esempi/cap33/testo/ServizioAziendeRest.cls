@RestResource(urlMapping='/v1/aziende/*')
global with sharing class ServizioAziendeRest {

    global class Scheda {
        global String id;
        global String nome;
        global String citta;
        global Integer contatti;
    }

    @HttpGet
    global static Scheda leggi() {
        RestRequest richiesta = RestContext.request;
        String chiave = richiesta.requestURI
            .substringAfterLast('/');
        List<Account> trovate = [
            SELECT Id, Name, BillingCity,
                (SELECT Id FROM Contacts)
            FROM Account
            WHERE Id = :chiave
            WITH USER_MODE
        ];
        if (trovate.isEmpty()) {
            RestContext.response.statusCode = 404;
            return null;
        }
        Scheda s = new Scheda();
        s.id = trovate[0].Id;
        s.nome = trovate[0].Name;
        s.citta = trovate[0].BillingCity;
        s.contatti = trovate[0].Contacts.size();
        return s;
    }
}
