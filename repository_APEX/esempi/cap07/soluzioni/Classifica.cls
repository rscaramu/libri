public class Classifica {

    private Map<String, Integer> punteggi =
        new Map<String, Integer>();

    public void registra(String nome, Integer punti) {
        Integer finora = punteggi.containsKey(nome)
            ? punteggi.get(nome) : 0;
        punteggi.put(nome, finora + punti);
    }

    public String migliore() {
        String vincitore;
        Integer massimo;
        for (String nome : punteggi.keySet()) {
            Integer punti = punteggi.get(nome);
            if (massimo == null || punti > massimo) {
                massimo = punti;
                vincitore = nome;
            }
        }
        return vincitore;
    }
}
