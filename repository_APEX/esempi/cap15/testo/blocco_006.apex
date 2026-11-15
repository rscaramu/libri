List<Account> ferme = [
    SELECT Name FROM Account
    WHERE Id NOT IN (SELECT AccountId FROM Opportunity)
    AND BillingCountry = 'Italia'
];
System.debug(ferme[0].Name);
