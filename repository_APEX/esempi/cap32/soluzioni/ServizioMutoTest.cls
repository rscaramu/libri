@IsTest
private class ServizioMutoTest {

    @IsTest
    static void ilTempoScadutoDiventaCambiException() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioMuto());

        try {
            new ClienteCambi().leggi('EUR');
            Assert.fail('Attesa CambiException');
        } catch (ClienteCambi.CambiException e) {
            Assert.isInstanceOfType(e.getCause(),
                CalloutException.class);
        }
    }
}
