public class Fatturazione {

    public static Decimal conIva(Decimal imponibile) {
        Decimal totale = imponibile * 1.22;
        return totale.setScale(2, RoundingMode.HALF_UP);
    }
}
