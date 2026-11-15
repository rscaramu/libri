public class Sconti {

    /**
     * Calcola il prezzo scontato.
     * @param prezzo prezzo di listino, non null
     * @param percentuale sconto da 0 a 100
     * @return prezzo scontato, con due decimali
     */
    public static Decimal applica(
            Decimal prezzo, Decimal percentuale) {
        Decimal fattore = 1 - percentuale / 100;
        return (prezzo * fattore).setScale(2);
    }
}
