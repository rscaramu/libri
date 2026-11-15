Set<String> scartati = InserimentoProtetto.aziende(
    new List<Account>{ new Account(
        Name = 'Prova Protetta',
        BillingCountry = 'Prova',
        AnnualRevenue = 100000) });
System.debug(scartati.size());
delete [SELECT Id FROM Account
    WHERE BillingCountry = 'Prova'];
