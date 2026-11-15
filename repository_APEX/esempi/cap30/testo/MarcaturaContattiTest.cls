@IsTest
private class MarcaturaContattiTest {

    @IsTest
    static void marcaIContattiEsistenti() {
        Account azienda = FabbricaDati.aziende(1)[0];
        List<Contact> contatti =
            FabbricaDati.contatti(azienda, 3);
        List<Id> chiavi = new List<Id>();
        for (Contact c : contatti) {
            chiavi.add(c.Id);
        }
        delete contatti[0];

        Test.startTest();
        MarcaturaContatti.marca(chiavi);
        Test.stopTest();

        Assert.areEqual(2, [SELECT COUNT() FROM Contact
            WHERE Description LIKE 'Elaborato il%']);
    }
}
