public class Statistiche {

    public static Map<String, Decimal> riepilogo(
            List<Decimal> valori) {
        Decimal somma = 0;
        Decimal massimo = valori[0];
        for (Decimal v : valori) {
            somma += v;
            massimo = Math.max(massimo, v);
        }
        return new Map<String, Decimal>{
            'somma' => somma,
            'massimo' => massimo,
            'media' => somma.divide(valori.size(), 2)
        };
    }
}
