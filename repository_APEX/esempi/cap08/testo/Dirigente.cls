public class Dirigente extends Dipendente {

    private Decimal premio;

    public Dirigente(String nome, Decimal stipendioBase,
            Decimal premio) {
        super(nome, stipendioBase);
        this.premio = premio;
    }

    public override Decimal compenso() {
        return stipendioBase * 1.20 + premio;
    }
}
