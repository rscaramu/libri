for (Account a : [SELECT Name FROM Account
        WHERE Id IN (SELECT AccountId FROM Contact
            WHERE Title = 'Buyer')
        AND BillingCountry = 'Italia'
        ORDER BY Name]) {
    System.debug(a.Name);
}
