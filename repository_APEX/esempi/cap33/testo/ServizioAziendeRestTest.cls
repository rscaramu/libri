@IsTest
private class ServizioAziendeRestTest {

    @IsTest
    static void restituisceLaSchedaDellAzienda() {
        Account azienda = FabbricaDati.aziende(1)[0];
        FabbricaDati.contatti(azienda, 2);
        RestRequest richiesta = new RestRequest();
        richiesta.requestURI =
            '/services/apexrest/v1/aziende/' + azienda.Id;
        richiesta.httpMethod = 'GET';
        RestContext.request = richiesta;
        RestContext.response = new RestResponse();

        ServizioAziendeRest.Scheda scheda =
            ServizioAziendeRest.leggi();

        Assert.areEqual('Azienda Test 0', scheda.nome);
        Assert.areEqual(2, scheda.contatti);
    }

    @IsTest
    static void aziendaInesistenteRisponde404() {
        RestRequest richiesta = new RestRequest();
        richiesta.requestURI =
            '/services/apexrest/v1/aziende/'
            + '001000000000000AAA';
        RestContext.request = richiesta;
        RestContext.response = new RestResponse();

        ServizioAziendeRest.Scheda scheda =
            ServizioAziendeRest.leggi();

        Assert.isNull(scheda);
        Assert.areEqual(404,
            RestContext.response.statusCode);
    }
}
