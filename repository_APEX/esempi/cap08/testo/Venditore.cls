public class Venditore extends Dipendente {

    private Decimal vendite;

    public Venditore(String nome, Decimal stipendioBase,
            Decimal vendite) {
        super(nome, stipendioBase);
        this.vendite = vendite;
    }

    public override Decimal compenso() {
        return super.compenso() + vendite * 0.03;
    }
}
