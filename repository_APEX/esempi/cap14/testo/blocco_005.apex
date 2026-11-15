List<Account> grandi = [
    SELECT Name, AnnualRevenue
    FROM Account
    WHERE BillingCountry = 'Italia'
        AND (AnnualRevenue > 1000000
            OR NumberOfEmployees > 100)
    ORDER BY AnnualRevenue DESC
];
for (Account a : grandi) {
    System.debug(a.Name + ': ' + a.AnnualRevenue);
}
