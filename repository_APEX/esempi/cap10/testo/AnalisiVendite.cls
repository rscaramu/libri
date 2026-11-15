public class AnalisiVendite {

    public class Esito {
        public Decimal totale { get; private set; }
        public Decimal media { get; private set; }
        public Integer numero { get; private set; }

        public Esito(Decimal totale, Integer numero) {
            this.totale = totale;
            this.numero = numero;
            this.media = numero == 0
                ? 0 : totale.divide(numero, 2);
        }
    }

    public static Esito analizza(List<Decimal> importi) {
        Decimal somma = 0;
        for (Decimal importo : importi) {
            somma += importo;
        }
        return new Esito(somma, importi.size());
    }
}
