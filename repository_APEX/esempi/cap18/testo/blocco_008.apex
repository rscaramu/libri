Integer q = Limits.getQueries();
Integer righe = Limits.getQueryRows();
List<Account> aziende = [
    SELECT Name, (SELECT LastName FROM Contacts)
    FROM Account
    WHERE BillingCountry = 'Italia'
];
System.debug(Limits.getQueries() - q);
System.debug(Limits.getQueryRows() - righe);
