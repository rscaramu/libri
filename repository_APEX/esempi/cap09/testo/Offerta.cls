public class Offerta implements Comparable {

    public String fornitore { get; private set; }
    public Decimal prezzo { get; private set; }

    public Offerta(String fornitore, Decimal prezzo) {
        this.fornitore = fornitore;
        this.prezzo = prezzo;
    }

    public Integer compareTo(Object altro) {
        Offerta o = (Offerta) altro;
        if (prezzo == o.prezzo) {
            return 0;
        }
        return prezzo < o.prezzo ? -1 : 1;
    }
}
