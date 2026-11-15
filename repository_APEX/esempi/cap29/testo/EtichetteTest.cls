@IsTest
private class EtichetteTest {

    @TestSetup
    static void prepara() {
        Account azienda = new Account(
            Name = 'Tecno Test', BillingCity = 'Lecce');
        insert azienda;
        insert new Opportunity(Name = 'Affare Test',
            AccountId = azienda.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 5000);
    }

    @IsTest
    static void scriveNomeECittaDellAzienda() {
        List<Opportunity> trattative = [
            SELECT Id, AccountId FROM Opportunity];

        Etichette.applica(trattative);

        Assert.areEqual('Tecno Test - Lecce',
            [SELECT Description FROM Opportunity
                LIMIT 1].Description);
    }

    @IsTest
    static void ignoraLeTrattativeSenzaAzienda() {
        Opportunity orfana = new Opportunity(
            Name = 'Orfana', StageName = 'Prospecting',
            CloseDate = Date.today());
        insert orfana;

        Etichette.applica(new List<Opportunity>{ orfana });

        Assert.isNull([SELECT Description
            FROM Opportunity
            WHERE Id = :orfana.Id].Description);
    }
}
