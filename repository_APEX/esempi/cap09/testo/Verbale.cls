public class Verbale implements Archiviabile, Pagabile {

    public String testoDiStampa() {
        return 'Verbale di collaudo';
    }

    public String codiceArchivio() {
        return 'VRB-0042';
    }

    public Decimal importoDovuto() {
        return 0;
    }

    public String causale() {
        return 'Nessun pagamento';
    }
}
