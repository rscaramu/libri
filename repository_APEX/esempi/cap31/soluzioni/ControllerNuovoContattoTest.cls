@IsTest
private class ControllerNuovoContattoTest {

    @IsTest
    static void creaIlContatto() {
        Account azienda = FabbricaDati.aziende(1)[0];

        Id nuovo = ControllerNuovoContatto.crea(
            azienda.Id, 'Ada', 'Neri', 'ada@test.example');

        Assert.areEqual('Neri', [SELECT LastName
            FROM Contact WHERE Id = :nuovo].LastName);
    }

    @IsTest
    static void cognomeVuotoSollevaErrore() {
        try {
            ControllerNuovoContatto.crea(
                null, 'Ada', ' ', null);
            Assert.fail('Attesa AuraHandledException');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('obbligatorio'));
        }
    }
}
