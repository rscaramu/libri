public class Nominativi {

    public static String iniziali(
            String nome, String cognome) {
        if (String.isBlank(nome)
                || String.isBlank(cognome)) {
            return '';
        }
        return nome.trim().left(1).toUpperCase() + '.'
            + cognome.trim().left(1).toUpperCase() + '.';
    }
}
