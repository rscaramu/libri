public class Fisco {

    public static final Decimal IVA_ORDINARIA = 0.22;
    public static final Decimal IVA_RIDOTTA = 0.10;
    public static final Integer GIORNI_PAGAMENTO = 30;

    public static Decimal lordo(Decimal netto) {
        return (netto * (1 + IVA_ORDINARIA)).setScale(2);
    }
}
