public class Codici {

    public static void verifica(String codice) {
        Boolean valido = codice != null
            && codice.length() == 4
            && codice.left(1).isAlpha()
            && codice.left(1).isAllUpperCase()
            && codice.mid(1, 1) == '-'
            && codice.right(2).isNumeric();
        if (!valido) {
            throw new CodiceNonValidoException(
                'Codice non valido: ' + codice);
        }
    }
}
