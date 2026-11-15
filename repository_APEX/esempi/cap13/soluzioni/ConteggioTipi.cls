public class ConteggioTipi {

    public static Map<String, Integer> perOggetto(
            List<sObject> record) {
        Map<String, Integer> esito =
            new Map<String, Integer>();
        for (sObject r : record) {
            String nome = String.valueOf(
                r.getSObjectType());
            Integer finora = esito.containsKey(nome)
                ? esito.get(nome) : 0;
            esito.put(nome, finora + 1);
        }
        return esito;
    }
}
