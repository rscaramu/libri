public class Sessione {

    private static Integer accessi = 0;

    public static void registraAccesso() {
        accessi++;
    }

    public static Integer totale() {
        return accessi;
    }
}
