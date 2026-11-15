List<Account> aziende = [
    SELECT Name, BillingCity
    FROM Account
    WHERE BillingCountry = 'Italia'
    ORDER BY Name
];
System.debug(aziende.size());
for (Account a : aziende) {
    System.debug(a.Name + ' - ' + a.BillingCity);
}
