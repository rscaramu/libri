@IsTest
private class ControllerScontiTest {

    @IsTest
    static void applicaLoScontoRichiesto() {
        Account azienda = FabbricaDati.aziende(1)[0];
        Opportunity o =
            FabbricaDati.trattativa(azienda, 1000);

        Decimal nuovo = ControllerSconti.applica(o.Id, 10);

        Assert.areEqual(900.00, nuovo);
    }

    @IsTest
    static void rifiutaUnoScontoEccessivo() {
        try {
            ControllerSconti.applica(null, 50);
            Assert.fail('Attesa AuraHandledException');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('fra 0 e 30'));
        }
    }
}
