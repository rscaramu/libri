@RestResource(urlMapping='/v1/trattative/*')
global with sharing class ServizioTrattativeRest {

    global class Scheda {
        global String nome;
        global String fase;
        global Decimal importo;
    }

    @HttpGet
    global static Scheda leggi() {
        String chiave = RestContext.request.requestURI
            .substringAfterLast('/');
        List<Opportunity> trovate = [
            SELECT Name, StageName, Amount
            FROM Opportunity WHERE Id = :chiave
            WITH USER_MODE];
        if (trovate.isEmpty()) {
            RestContext.response.statusCode = 404;
            return null;
        }
        Scheda s = new Scheda();
        s.nome = trovate[0].Name;
        s.fase = trovate[0].StageName;
        s.importo = trovate[0].Amount;
        return s;
    }
}
