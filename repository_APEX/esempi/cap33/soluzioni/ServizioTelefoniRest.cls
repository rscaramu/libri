@RestResource(urlMapping='/v1/telefoni/*')
global with sharing class ServizioTelefoniRest {

    @HttpPatch
    global static void aggiorna(String telefono) {
        String chiave = RestContext.request.requestURI
            .substringAfterLast('/');
        if (String.isBlank(telefono)) {
            RestContext.response.statusCode = 400;
            return;
        }
        if ([SELECT COUNT() FROM Account
                WHERE Id = :chiave] == 0) {
            RestContext.response.statusCode = 404;
            return;
        }
        try {
            update as user new Account(
                Id = chiave, Phone = telefono);
            RestContext.response.statusCode = 204;
        } catch (DmlException e) {
            RestContext.response.statusCode = 403;
        }
    }
}
