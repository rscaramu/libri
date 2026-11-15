public class Furgone extends Veicolo {

    private Decimal portata;

    public Furgone(String targa, Decimal portata) {
        super(targa, 3);
        this.portata = portata;
    }

    public Boolean puoCaricare(Decimal peso) {
        return peso <= portata;
    }
}
