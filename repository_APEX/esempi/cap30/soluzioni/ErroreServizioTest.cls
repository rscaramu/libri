@IsTest
private class ErroreServizioTest {

    @IsTest
    static void ilChiamanteRiceveLoStato500() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioFinto(500, '{"errore":"guasto"}'));
        HttpRequest richiesta = new HttpRequest();
        richiesta.setEndpoint('https://esempio.test/v1');
        richiesta.setMethod('GET');

        HttpResponse risposta = new Http().send(richiesta);

        Assert.areEqual(500, risposta.getStatusCode());
    }
}
