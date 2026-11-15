public class Spedizioni {

    public static Decimal costo(Decimal peso) {
        return costo(peso, false);
    }

    public static Decimal costo(
            Decimal peso, Boolean urgente) {
        Decimal base = 5 + peso * 1.20;
        return urgente ? base * 2 : base;
    }
}
