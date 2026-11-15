List<Account> ordinate = [
    SELECT Name, Rating
    FROM Account
    WHERE BillingCountry = 'Italia'
    ORDER BY Rating NULLS LAST, Name DESC
    LIMIT 3
];
for (Account a : ordinate) {
    System.debug(a.Rating + ' ' + a.Name);
}
