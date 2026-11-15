@IsTest
private class FiltriTest {

    @IsTest
    static void restituisceISoliPari() {
        List<Integer> dati =
            new List<Integer>{ 3, 8, 5, 12, 6 };

        List<Integer> pari = Filtri.soloPari(dati);

        Assert.areEqual(
            new List<Integer>{ 8, 12, 6 }, pari);
        Assert.areEqual(5, dati.size(),
            'La lista ricevuta non va modificata');
    }

    @IsTest
    static void senzaPariRestituisceListaVuota() {
        Assert.isTrue(Filtri.soloPari(
            new List<Integer>{ 1, 3 }).isEmpty());
    }

    @IsTest
    static void conListaVuotaONullaNonSollevaErrori() {
        Assert.isTrue(Filtri.soloPari(
            new List<Integer>()).isEmpty());
        Assert.isTrue(Filtri.soloPari(null).isEmpty());
    }
}
