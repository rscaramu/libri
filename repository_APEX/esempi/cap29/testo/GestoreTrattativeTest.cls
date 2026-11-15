@IsTest
private class GestoreTrattativeTest {

    @IsTest
    static void importoNegativoRespinto() {
        Opportunity negativa = new Opportunity(
            Name = 'Negativa', StageName = 'Prospecting',
            CloseDate = Date.today(), Amount = -1);

        Database.SaveResult esito =
            Database.insert(negativa, false);

        Assert.isFalse(esito.isSuccess());
        Assert.isTrue(esito.getErrors()[0].getMessage()
            .contains('negativo'));
    }
}
