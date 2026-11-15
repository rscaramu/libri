public class Controlli {

    private static final String MODELLO_POSTA =
        '[\\w.-]+@[\\w-]+(\\.[\\w-]+)+';

    public static Boolean postaValida(String indirizzo) {
        if (String.isBlank(indirizzo)) {
            return false;
        }
        return Pattern.matches(
            MODELLO_POSTA, indirizzo.trim());
    }
}
