public class Triangolo extends Figura {

    private Decimal base;
    private Decimal altezza;

    public Triangolo(Decimal base, Decimal altezza) {
        super('Triangolo');
        this.base = base;
        this.altezza = altezza;
    }

    public override Decimal area() {
        return base * altezza / 2;
    }
}
