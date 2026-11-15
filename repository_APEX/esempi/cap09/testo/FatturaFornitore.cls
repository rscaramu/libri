public class FatturaFornitore implements Pagabile {

    private String numero;
    private Decimal imponibile;

    public FatturaFornitore(String numero,
            Decimal imponibile) {
        this.numero = numero;
        this.imponibile = imponibile;
    }

    public Decimal importoDovuto() {
        return (imponibile * 1.22).setScale(2);
    }

    public String causale() {
        return 'Fattura ' + numero;
    }
}
