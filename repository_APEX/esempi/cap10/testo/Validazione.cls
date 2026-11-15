public class Validazione {

    public class Esito {
        public List<String> errori { get; private set; }
        public Boolean valido {
            get { return errori.isEmpty(); }
        }

        public Esito() {
            errori = new List<String>();
        }
    }

    public static Esito controlla(
            String nominativo, Integer eta) {
        Esito esito = new Esito();
        if (String.isBlank(nominativo)) {
            esito.errori.add('Nominativo mancante');
        }
        if (eta == null || eta < 18 || eta > 100) {
            esito.errori.add('Eta\' non ammessa');
        }
        return esito;
    }
}
