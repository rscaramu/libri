public class LetturaStati {

    public static StatoOrdine stato(String testo) {
        try {
            return StatoOrdine.valueOf(testo);
        } catch (Exception e) {
            throw new StatoSconosciutoException(
                'Stato sconosciuto: ' + testo, e);
        }
    }
}
