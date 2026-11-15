@IsTest
private class RiepilogoTest {

    @IsTest
    static void scriveIlNumeroDeiContatti() {
        Account azienda = new Account(Name = 'Azienda Test');
        insert azienda;
        insert new List<Contact>{
            new Contact(LastName = 'Uno',
                AccountId = azienda.Id),
            new Contact(LastName = 'Due',
                AccountId = azienda.Id)
        };

        Riepilogo.aggiorna(new List<Account>{ azienda });

        Account riletta = [SELECT Description
            FROM Account WHERE Id = :azienda.Id];
        Assert.areEqual('Contatti: 2',
            riletta.Description);
    }

    @IsTest
    static void aziendaSenzaContattiRiceveZero() {
        Account azienda = new Account(Name = 'Sola');
        insert azienda;

        Riepilogo.aggiorna(new List<Account>{ azienda });

        Assert.areEqual('Contatti: 0',
            [SELECT Description FROM Account
                WHERE Id = :azienda.Id].Description);
    }
}
