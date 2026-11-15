Etichette.applica([SELECT Id, AccountId
    FROM Opportunity
    WHERE Account.BillingCountry = 'Italia']);
System.debug([SELECT Description FROM Opportunity
    WHERE Name = 'Portale clienti'].Description);
System.debug(Limits.getQueries());
System.debug(Limits.getDmlStatements());
