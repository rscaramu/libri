@IsTest
private class PortafoglioTest {

    @IsTest
    static void prelievoEccessivoSollevaEccezione() {
        Portafoglio p = new Portafoglio(200);

        try {
            p.preleva(500);
            Assert.fail('Attesa eccezione di saldo');
        } catch (SaldoInsufficienteException e) {
            Assert.isTrue(
                e.getMessage().contains('500'),
                'Il messaggio deve citare la richiesta');
        }
    }

    @IsTest
    static void prelievoAmmessoRiduceIlSaldo() {
        Portafoglio p = new Portafoglio(200);

        p.preleva(50);
        p.preleva(150);

        try {
            p.preleva(1);
            Assert.fail('Il saldo doveva essere zero');
        } catch (SaldoInsufficienteException e) {
            Assert.isTrue(true);
        }
    }
}
