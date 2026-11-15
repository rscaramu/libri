public class NotaSpese implements Pagabile {

    private String dipendente;
    private Decimal totale;

    public NotaSpese(String dipendente, Decimal totale) {
        this.dipendente = dipendente;
        this.totale = totale;
    }

    public Decimal importoDovuto() {
        return totale;
    }

    public String causale() {
        return 'Rimborso a ' + dipendente;
    }
}
