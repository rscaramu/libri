@IsTest
private class ClienteCambiTest {

    private static final String RISPOSTA =
        '{"base":"EUR","data":"2026-11-13",'
        + '"tassi":{"USD":1.08,"GBP":0.85}}';

    @IsTest
    static void interpretaUnaRispostaCorretta() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioFinto(200, RISPOSTA));

        Test.startTest();
        ClienteCambi.Listino listino =
            new ClienteCambi().leggi('EUR');
        Test.stopTest();

        Assert.areEqual('EUR', listino.base);
        Assert.areEqual(1.08, listino.tassi.get('USD'));
        Assert.areEqual(2, listino.tassi.size());
    }

    @IsTest
    static void unErroreDelServizioDiventaEccezione() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioFinto(503, 'Non disponibile'));

        try {
            new ClienteCambi().leggi('EUR');
            Assert.fail('Attesa CambiException');
        } catch (ClienteCambi.CambiException e) {
            Assert.isTrue(e.getMessage().contains('503'));
        }
    }

    @IsTest
    static void unCorpoMalformatoDiventaEccezione() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioFinto(200, '<html>errore</html>'));

        try {
            new ClienteCambi().leggi('EUR');
            Assert.fail('Attesa CambiException');
        } catch (ClienteCambi.CambiException e) {
            Assert.isInstanceOfType(e.getCause(),
                JSONException.class);
        }
    }
}
