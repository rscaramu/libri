public class Contatore2 {

    private static Integer chiamate = 0;

    public static void segna() {
        chiamate++;
    }

    public static Integer totale() {
        return chiamate;
    }
}
