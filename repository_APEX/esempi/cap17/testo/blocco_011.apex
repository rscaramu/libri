delete [SELECT Id FROM Account
    WHERE BillingCountry = 'Prova'];
System.debug([SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Prova']);
