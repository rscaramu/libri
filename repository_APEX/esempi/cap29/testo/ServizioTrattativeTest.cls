@IsTest
private class ServizioTrattativeTest {

    @IsTest
    static void creaUnaVerificaPerOgniTrattativaRilevante() {
        List<Opportunity> trattative =
            new List<Opportunity>();
        for (Integer i = 0; i < 200; i++) {
            trattative.add(new Opportunity(
                Name = 'Blocco ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(10),
                Amount = Math.mod(i, 2) == 0
                    ? 150000 : 1000));
        }

        Test.startTest();
        insert trattative;
        Test.stopTest();

        Assert.areEqual(100, [SELECT COUNT() FROM Task
            WHERE Subject LIKE 'Verifica%']);
    }
}
