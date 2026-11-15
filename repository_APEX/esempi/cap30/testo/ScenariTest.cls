@IsTest
private class ScenariTest {

    @IsTest
    static void leSottointerrogazioniPortanoIFigli() {
        FabbricaScenari.aziendaCompleta(3, 2);

        Account letta = [
            SELECT Name,
                (SELECT Id FROM Contacts),
                (SELECT Amount FROM Opportunities
                    WHERE IsWon = true)
            FROM Account LIMIT 1];

        Assert.areEqual(3, letta.Contacts.size());
        Assert.areEqual(2, letta.Opportunities.size());
    }
}
