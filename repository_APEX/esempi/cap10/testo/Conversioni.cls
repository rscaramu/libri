public class Conversioni {

    public static final Decimal KM_PER_MIGLIO = 1.609344;
    public static final Decimal KG_PER_LIBBRA = 0.45359237;

    public static Decimal inChilometri(Decimal miglia) {
        return (miglia * KM_PER_MIGLIO).setScale(2);
    }

    public static Decimal inChilogrammi(Decimal libbre) {
        return (libbre * KG_PER_LIBBRA).setScale(2);
    }
}
