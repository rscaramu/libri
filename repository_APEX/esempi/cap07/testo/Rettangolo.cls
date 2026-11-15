public class Rettangolo {

    public Decimal base { get; private set; }
    public Decimal altezza { get; private set; }
    public Decimal area {
        get { return base * altezza; }
    }
    public Decimal perimetro {
        get { return 2 * (base + altezza); }
    }

    public Rettangolo(Decimal base, Decimal altezza) {
        this.base = base;
        this.altezza = altezza;
    }
}
