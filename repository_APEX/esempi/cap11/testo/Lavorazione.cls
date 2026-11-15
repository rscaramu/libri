public class Lavorazione {

    public static void esegui(Integer pezzi) {
        System.debug('Inizio');
        try {
            Integer perScatola = 120 / pezzi;
            System.debug('Scatole da ' + perScatola);
        } catch (MathException e) {
            System.debug('Numero di pezzi non valido');
        } finally {
            System.debug('Fine');
        }
    }
}
