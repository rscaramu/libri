public class Listino {

    private static Map<String, Decimal> prezzi;

    public static Decimal prezzoDi(String codice) {
        if (prezzi == null) {
            System.debug('Carico il listino');
            prezzi = new Map<String, Decimal>{
                'V-10' => 0.12, 'D-08' => 0.05 };
        }
        return prezzi.get(codice);
    }
}
