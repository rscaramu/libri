@IsTest
private class ImportazioneTest {

    @IsTest
    static void salvaISoliContattiValidi() {
        List<Contact> lista = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            lista.add(new Contact(
                LastName = i < 150 ? 'Valido ' + i : null,
                FirstName = 'Prova'));
        }

        Test.startTest();
        Integer salvati = Importazione.contatti(lista);
        Test.stopTest();

        Assert.areEqual(150, salvati);
        Assert.areEqual(150,
            [SELECT COUNT() FROM Contact]);
    }
}
