public virtual class Conto {

    protected Decimal saldo = 0;

    public void versa(Decimal importo) {
        if (importo > 0) {
            saldo += importo;
        }
    }

    public Decimal leggiSaldo() {
        return saldo;
    }
}
