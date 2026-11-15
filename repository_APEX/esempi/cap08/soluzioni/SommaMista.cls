public class SommaMista {

    public static Decimal numerici(List<Object> valori) {
        Decimal somma = 0;
        for (Object v : valori) {
            if (v instanceof Integer) {
                somma += (Integer) v;
            } else if (v instanceof Decimal) {
                somma += (Decimal) v;
            }
        }
        return somma;
    }
}
