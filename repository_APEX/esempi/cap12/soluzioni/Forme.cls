public class Forme {

    public static Boolean capValido(String cap) {
        return cap != null
            && Pattern.matches('\\d{5}', cap);
    }

    public static Boolean targaValida(String targa) {
        return targa != null && Pattern.matches(
            '[A-Z]{2}\\d{3}[A-Z]{2}', targa);
    }
}
