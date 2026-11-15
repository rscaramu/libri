public class Cerchio2 {

    private static final Decimal PI_GRECO = 3.14159;

    public static Decimal area(Decimal raggio) {
        return (PI_GRECO * raggio * raggio).setScale(2);
    }

    public static Decimal circonferenza(Decimal raggio) {
        return (2 * PI_GRECO * raggio).setScale(2);
    }
}
