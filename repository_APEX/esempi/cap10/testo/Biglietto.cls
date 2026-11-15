public class Biglietto {

    private static Integer emessi = 0;
    public Integer numero { get; private set; }

    public Biglietto() {
        emessi++;
        numero = emessi;
    }

    public static Integer totaleEmessi() {
        return emessi;
    }
}
