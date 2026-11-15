List<Account> vincenti = [
    SELECT Name FROM Account
    WHERE Id IN (SELECT AccountId FROM Opportunity
        WHERE StageName = 'Closed Won')
    AND BillingCountry = 'Italia'
    ORDER BY Name
];
for (Account a : vincenti) {
    System.debug(a.Name);
}
