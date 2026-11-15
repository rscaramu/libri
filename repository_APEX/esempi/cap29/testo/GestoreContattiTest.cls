@IsTest
private class GestoreContattiTest {

    @IsTest
    static void normalizzaPostaERuolo() {
        Contact c = new Contact(LastName = 'Test',
            Email = 'NOME@ESEMPIO.IT');

        insert c;

        Contact riletto = [SELECT Email, Title
            FROM Contact WHERE Id = :c.Id];
        Assert.areEqual('nome@esempio.it', riletto.Email);
        Assert.areEqual('Da definire', riletto.Title);
    }

    @IsTest
    static void nonSovrascriveUnRuoloIndicato() {
        Contact c = new Contact(LastName = 'Test',
            Title = 'Titolare');

        insert c;

        Assert.areEqual('Titolare', [SELECT Title
            FROM Contact WHERE Id = :c.Id].Title);
    }
}
