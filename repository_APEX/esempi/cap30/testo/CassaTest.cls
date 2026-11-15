@IsTest
private class CassaTest {

    private class ScontoFisso implements PoliticaSconto {
        public Decimal applica(Decimal importo) {
            return importo - 10;
        }
    }

    @IsTest
    static void ilTotaleApplicaLaPoliticaRicevuta() {
        Cassa cassa = new Cassa(new ScontoFisso());

        Decimal totale = cassa.totale(
            new List<Decimal>{ 40, 25, 35 });

        Assert.areEqual(90, totale);
    }
}
