public class ContoRisparmio extends Conto {

    private Decimal tasso;

    public ContoRisparmio(Decimal tasso) {
        this.tasso = tasso;
    }

    public void maturaInteressi() {
        saldo += (saldo * tasso / 100).setScale(2);
    }
}
