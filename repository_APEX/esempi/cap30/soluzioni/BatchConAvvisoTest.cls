@IsTest
private class BatchConAvvisoTest {

    @IsTest
    static void impostaColdSoloDoveManca() {
        List<Account> aziende = FabbricaDati.aziende(3);
        aziende[0].Rating = 'Hot';
        update aziende[0];

        Test.startTest();
        Database.executeBatch(new BatchConAvviso());
        Test.stopTest();

        Assert.areEqual(2, [SELECT COUNT() FROM Account
            WHERE Rating = 'Cold']);
        Assert.areEqual(1, [SELECT COUNT() FROM Account
            WHERE Rating = 'Hot']);
    }
}
