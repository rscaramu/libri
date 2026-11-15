@IsTest
private class GestoreLeadTest {

    @IsTest
    static void duecentoLeadRicevonoLaValutazione() {
        Test.startTest();
        FabbricaLead.lead(200);
        Test.stopTest();

        Assert.areEqual(200, [SELECT COUNT() FROM Lead
            WHERE Rating = 'Warm']);
    }
}
