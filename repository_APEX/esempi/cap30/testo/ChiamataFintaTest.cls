@IsTest
private class ChiamataFintaTest {

    @IsTest
    static void ilCodiceRiceveLaRispostaFinta() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioFinto(200, '{"esito":"ok"}'));
        HttpRequest richiesta = new HttpRequest();
        richiesta.setEndpoint('https://esempio.test/v1');
        richiesta.setMethod('GET');

        Test.startTest();
        HttpResponse risposta = new Http().send(richiesta);
        Test.stopTest();

        Assert.areEqual(200, risposta.getStatusCode());
        Assert.isTrue(risposta.getBody().contains('ok'));
    }
}
