public class RigaOrdine {

    public String descrizione { get; private set; }
    public Integer quantita { get; private set; }
    public Decimal prezzo { get; private set; }

    public RigaOrdine(String descrizione,
            Integer quantita, Decimal prezzo) {
        this.descrizione = descrizione;
        this.quantita = quantita;
        this.prezzo = prezzo;
    }

    public Decimal importo() {
        return quantita * prezzo;
    }
}
