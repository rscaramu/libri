public class Articolo {

    public String codice;
    public Decimal prezzo;
    public Integer scorta;

    public Articolo(String codice, Decimal prezzo) {
        this(codice, prezzo, 0);
    }

    public Articolo(String codice, Decimal prezzo,
            Integer scorta) {
        this.codice = codice;
        this.prezzo = prezzo;
        this.scorta = scorta;
    }
}
