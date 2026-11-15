public class Stanza implements Misurabile {

    private Decimal larghezza;
    private Decimal lunghezza;

    public Stanza(Decimal larghezza, Decimal lunghezza) {
        this.larghezza = larghezza;
        this.lunghezza = lunghezza;
    }

    public Decimal superficie() {
        return larghezza * lunghezza;
    }
}
