public class Inventario {

    public class Voce {
        public String codice;
        public Integer quantita;

        public Voce(String codice, Integer quantita) {
            this.codice = codice;
            this.quantita = quantita;
        }
    }

    public static List<Voce> sottoScorta(
            List<Voce> voci, Integer soglia) {
        List<Voce> scarse = new List<Voce>();
        for (Voce v : voci) {
            if (v.quantita < soglia) {
                scarse.add(v);
            }
        }
        return scarse;
    }
}
