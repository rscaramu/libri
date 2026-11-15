public class Immobile implements Tassabile {

    private Decimal valore;

    public Immobile(Decimal valore) {
        this.valore = valore;
    }

    public Decimal imposta() {
        return valore * 0.01;
    }
}
