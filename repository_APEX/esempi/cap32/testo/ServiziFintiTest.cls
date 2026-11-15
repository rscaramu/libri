@IsTest
private class ServiziFintiTest {

    @IsTest
    static void rispondeSecondoLIndirizzo() {
        Test.setMock(HttpCalloutMock.class,
            new ServiziFinti(new Map<String, String>{
                '/cambi' => '{"base":"EUR"}',
                '/spedizioni' => '{"codice":"SP-1"}' }));
        HttpRequest richiesta = new HttpRequest();
        richiesta.setEndpoint('https://x.test/spedizioni');
        richiesta.setMethod('GET');

        HttpResponse risposta = new Http().send(richiesta);

        Assert.isTrue(risposta.getBody().contains('SP-1'));
    }
}
