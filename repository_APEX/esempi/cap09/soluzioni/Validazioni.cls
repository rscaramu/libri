public class Validazioni {

    public static Boolean tutti(String testo,
            List<Validatore> validatori) {
        for (Validatore v : validatori) {
            if (!v.valido(testo)) {
                return false;
            }
        }
        return true;
    }
}
