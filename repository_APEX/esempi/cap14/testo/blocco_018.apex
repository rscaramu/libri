List<Account> prime = [
    SELECT Name, AnnualRevenue
    FROM Account
    WHERE BillingCountry = 'Italia'
    ORDER BY AnnualRevenue DESC
    LIMIT 2
];
for (Account a : prime) {
    System.debug(a.Name + ': ' + a.AnnualRevenue);
}
