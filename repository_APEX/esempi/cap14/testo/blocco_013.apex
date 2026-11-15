Integer quante = [SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Italia'];
System.debug(quante);
