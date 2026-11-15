public class Termometro {

    public Decimal celsius {
        get;
        set {
            if (value >= -273.15) {
                celsius = value;
            }
        }
    }
    public Decimal fahrenheit {
        get { return celsius * 9 / 5 + 32; }
    }

    public Termometro(Decimal iniziale) {
        celsius = 0;
        celsius = iniziale;
    }
}
