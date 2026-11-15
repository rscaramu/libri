public class Portafoglio {

    private Decimal saldo;

    public Portafoglio(Decimal saldoIniziale) {
        saldo = saldoIniziale;
    }

    public void preleva(Decimal importo) {
        if (importo > saldo) {
            throw new SaldoInsufficienteException(
                'Richiesti ' + importo
                + ', disponibili ' + saldo);
        }
        saldo -= importo;
    }
}
