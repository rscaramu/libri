@RestResource(urlMapping='/v1/rubrica/*')
global with sharing class ServizioRubricaRest {

    @HttpDelete
    global static void cancella() {
        String chiave = RestContext.request.requestURI
            .substringAfterLast('/');
        List<Contact> trovati = [SELECT Id FROM Contact
            WHERE Id = :chiave];
        if (trovati.isEmpty()) {
            RestContext.response.statusCode = 404;
            return;
        }
        try {
            delete as user trovati;
            RestContext.response.statusCode = 204;
        } catch (DmlException e) {
            RestContext.response.statusCode = 403;
        }
    }
}
