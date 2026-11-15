public class Cassa {

    private PoliticaSconto politica;

    public Cassa(PoliticaSconto politica) {
        this.politica = politica;
    }

    public Decimal totale(List<Decimal> prezzi) {
        Decimal somma = 0;
        for (Decimal p : prezzi) {
            somma += p;
        }
        return politica.applica(somma);
    }
}
