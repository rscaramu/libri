@IsTest
private class RiepilogoLimitiTest {

    @IsTest
    static void unaQueryEUnaScritturaPerDuecentoAziende() {
        List<Account> aziende = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            aziende.add(new Account(Name = 'Blocco ' + i));
        }
        insert aziende;

        Test.startTest();
        Riepilogo.aggiorna(aziende);
        Integer interrogazioni = Limits.getQueries();
        Integer scritture = Limits.getDmlStatements();
        Test.stopTest();

        Assert.areEqual(1, interrogazioni);
        Assert.areEqual(1, scritture);
    }
}
