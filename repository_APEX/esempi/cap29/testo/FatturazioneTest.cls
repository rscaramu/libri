@IsTest
private class FatturazioneTest {

    @IsTest
    static void conIvaApplicaIlVentiduePerCento() {
        Decimal imponibile = 150;

        Decimal lordo = Fatturazione.conIva(imponibile);

        Assert.areEqual(183.00, lordo,
            'Il lordo di 150 deve essere 183');
    }

    @IsTest
    static void conIvaArrotondaAlCentesimo() {
        Decimal lordo = Fatturazione.conIva(19.99);

        Assert.areEqual(24.39, lordo);
    }
}
