public class Prodotto {

    public String codice;
    public Decimal prezzo;
    public Integer scorta = 0;

    public Decimal valoreScorta() {
        return prezzo * scorta;
    }
}
