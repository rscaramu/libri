public class ScontoPercentuale implements PoliticaSconto {

    private Decimal percentuale;

    public ScontoPercentuale(Decimal percentuale) {
        this.percentuale = percentuale;
    }

    public Decimal applica(Decimal importo) {
        return (importo * (100 - percentuale) / 100)
            .setScale(2);
    }
}
