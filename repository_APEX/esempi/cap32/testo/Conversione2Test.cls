@IsTest
private class Conversione2Test {

    @IsTest
    static void converteConIlTassoRicevuto() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioFinto(200, '{"base":"EUR",'
                + '"tassi":{"USD":1.10}}'));

        Test.startTest();
        Decimal dollari = Conversione2.daEuro(200, 'USD');
        Test.stopTest();

        Assert.areEqual(220.00, dollari);
    }
}
