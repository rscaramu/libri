public class Cerchio extends Figura {

    private Decimal raggio;

    public Cerchio(Decimal raggio) {
        super('Cerchio');
        this.raggio = raggio;
    }

    public override Decimal area() {
        return 3.14159 * raggio * raggio;
    }
}
