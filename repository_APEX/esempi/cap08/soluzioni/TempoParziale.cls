public class TempoParziale extends Dipendente2 {

    private Integer ore;

    public TempoParziale(Integer ore) {
        this.ore = ore;
    }

    public override Integer oreSettimanali() {
        return ore;
    }
}
