@IsTest
private class AnagrafeTest {

    @IsTest
    static void etaEccessivaSollevaEccezione() {
        try {
            Anagrafe.registra('Ugo', 150);
            Assert.fail('Attesa EtaNonValidaException');
        } catch (EtaNonValidaException e) {
            Assert.isTrue(e.getMessage().contains('Ugo'));
            Assert.isTrue(e.getMessage().contains('150'));
        }
    }
}
