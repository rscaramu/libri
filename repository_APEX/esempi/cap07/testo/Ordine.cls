public class Ordine {

    private List<RigaOrdine> righe =
        new List<RigaOrdine>();

    public void aggiungi(RigaOrdine riga) {
        righe.add(riga);
    }

    public Decimal totale() {
        Decimal somma = 0;
        for (RigaOrdine riga : righe) {
            somma += riga.importo();
        }
        return somma;
    }
}
