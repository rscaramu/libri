List<Account> aziende = [SELECT Id FROM Account
    WHERE BillingCountry = 'Italia'];
Integer q = Limits.getQueries();
Integer d = Limits.getDmlStatements();
Riepilogo.aggiorna(aziende);
System.debug(Limits.getQueries() - q);
System.debug(Limits.getDmlStatements() - d);
System.debug([SELECT Description FROM Account
    WHERE Name = 'Energia Blu'].Description);
