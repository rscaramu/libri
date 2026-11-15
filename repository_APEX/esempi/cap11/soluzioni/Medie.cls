public class Medie {

    public static Decimal mediaSicura(
            List<Decimal> valori) {
        if (valori == null || valori.isEmpty()) {
            return 0;
        }
        Decimal somma = 0;
        for (Decimal v : valori) {
            somma += v ?? 0;
        }
        return somma.divide(valori.size(), 2);
    }
}
