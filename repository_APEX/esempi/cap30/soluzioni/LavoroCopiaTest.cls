@IsTest
private class LavoroCopiaTest {

    @IsTest
    static void creaUnaCopiaPerOgniAzienda() {
        List<Account> originali = FabbricaDati.aziende(2);

        Test.startTest();
        System.enqueueJob(new LavoroCopia(originali));
        Test.stopTest();

        Assert.areEqual(2, [SELECT COUNT() FROM Account
            WHERE Name LIKE '%(copia)']);
        Assert.areEqual(1, [SELECT COUNT() FROM Account
            WHERE Name = 'Azienda Test 0 (copia)']);
    }
}
