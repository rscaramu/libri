@IsTest
private class PermessiTest {

    @IsTest
    static void senzaPermessoIlControlloEFalso() {
        User utente = FabbricaUtenti.standard();

        System.runAs(utente) {
            Assert.isFalse(FeatureManagement
                .checkPermission('Approva_Sconti_Elevati'));
        }
    }
}
