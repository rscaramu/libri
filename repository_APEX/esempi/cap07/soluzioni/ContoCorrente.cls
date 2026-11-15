public class ContoCorrente {

    public Decimal saldo { get; private set; }

    public ContoCorrente() {
        saldo = 0;
    }

    public void versa(Decimal importo) {
        if (importo > 0) {
            saldo += importo;
        }
    }

    public Boolean preleva(Decimal importo) {
        if (importo <= 0 || importo > saldo) {
            return false;
        }
        saldo -= importo;
        return true;
    }
}
