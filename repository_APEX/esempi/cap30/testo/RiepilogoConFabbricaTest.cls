@IsTest
private class RiepilogoConFabbricaTest {

    @IsTest
    static void contaIContattiDiOgniAzienda() {
        List<Account> aziende = FabbricaDati.aziende(2);
        FabbricaDati.contatti(aziende[0], 3);

        Riepilogo.aggiorna(aziende);

        Map<Id, Account> rilette = new Map<Id, Account>([
            SELECT Description FROM Account]);
        Assert.areEqual('Contatti: 3',
            rilette.get(aziende[0].Id).Description);
        Assert.areEqual('Contatti: 0',
            rilette.get(aziende[1].Id).Description);
    }
}
