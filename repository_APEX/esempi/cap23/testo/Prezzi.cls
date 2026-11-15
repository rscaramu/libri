public with sharing class Prezzi {

    public static Decimal lordo(Decimal netto) {
        Decimal aliquota =
            Parametri2.numero('Aliquota_IVA', 0.22);
        return (netto * (1 + aliquota))
            .setScale(2, RoundingMode.HALF_UP);
    }
}
