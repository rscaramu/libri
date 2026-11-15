public class NessunoSconto implements PoliticaSconto {

    public Decimal applica(Decimal importo) {
        return importo;
    }
}
