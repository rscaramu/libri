public class Elaborazione {

    public static void esegui(Integer divisore) {
        try {
            System.debug('Risultato: ' + 100 / divisore);
        } catch (MathException e) {
            System.debug('Divisore non valido');
        } finally {
            System.debug('Elaborazione conclusa');
        }
    }
}
