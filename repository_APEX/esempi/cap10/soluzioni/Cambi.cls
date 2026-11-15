public class Cambi {

    private static Map<String, Decimal> tassi;

    private static Map<String, Decimal> carica() {
        if (tassi == null) {
            tassi = new Map<String, Decimal>{
                'USD' => 0.92, 'GBP' => 1.17,
                'CHF' => 1.06 };
        }
        return tassi;
    }

    public static Decimal inEuro(Decimal importo,
            String valuta) {
        Decimal tasso = carica().get(valuta);
        if (tasso == null) {
            return null;
        }
        return (importo * tasso).setScale(2);
    }
}
