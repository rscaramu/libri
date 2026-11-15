@IsTest
private class AsincronoTest {

    @IsTest
    static void ilMetodoFutureAggiornaLeDescrizioni() {
        List<Account> aziende = FabbricaDati.aziende(1);
        FabbricaDati.contatti(aziende[0], 2);

        Test.startTest();
        RiepilogoAsincrono.aggiorna(
            new Set<Id>{ aziende[0].Id });
        Test.stopTest();

        Assert.areEqual('Contatti: 2',
            [SELECT Description FROM Account
                LIMIT 1].Description);
    }

    @IsTest
    static void ilLavoroInCodaAggiornaLeDescrizioni() {
        List<Account> aziende = FabbricaDati.aziende(1);

        Test.startTest();
        System.enqueueJob(new LavoroRiepilogo(
            new Set<Id>{ aziende[0].Id }));
        Test.stopTest();

        Assert.areEqual('Contatti: 0',
            [SELECT Description FROM Account
                LIMIT 1].Description);
    }

    @IsTest
    static void ilBatchElaboraTutteLeAziende() {
        List<Account> aziende = FabbricaDati.aziende(50);
        FabbricaDati.contatti(aziende[7], 4);

        Test.startTest();
        Database.executeBatch(
            new BatchRiepilogoContatti(), 200);
        Test.stopTest();

        Assert.areEqual(1, [SELECT COUNT() FROM Account
            WHERE Description = 'Contatti: 4']);
        Assert.areEqual(49, [SELECT COUNT() FROM Account
            WHERE Description = 'Contatti: 0']);
    }
}
