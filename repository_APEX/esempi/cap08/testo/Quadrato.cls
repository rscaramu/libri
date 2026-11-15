public class Quadrato extends Figura {

    private Decimal lato;

    public Quadrato(Decimal lato) {
        super('Quadrato');
        this.lato = lato;
    }

    public override Decimal area() {
        return lato * lato;
    }
}
