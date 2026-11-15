public class Temperature {

    public static Decimal inFahrenheit(Decimal celsius) {
        return (celsius * 9 / 5 + 32).setScale(1);
    }

    public static Decimal inCelsius(Decimal fahrenheit) {
        return ((fahrenheit - 32) * 5 / 9).setScale(1);
    }
}
