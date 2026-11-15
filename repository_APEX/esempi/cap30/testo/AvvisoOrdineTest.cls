@IsTest
private class AvvisoOrdineTest {

    @IsTest
    static void ordineUrgenteCreaUnAttivita() {
        Test.startTest();
        EventBus.publish(new Avviso_Ordine__e(
            Codice_Ordine__c = 'ORD-TEST',
            Importo__c = 100,
            Urgente__c = true));
        Test.getEventBus().deliver();
        Test.stopTest();

        Assert.areEqual(1, [SELECT COUNT() FROM Task
            WHERE Subject = 'Ordine urgente ORD-TEST']);
    }
}
