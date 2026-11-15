Set<String> citta = new Set<String>{ 'Torino', 'Milano' };
List<Account> nord = [
    SELECT Name FROM Account
    WHERE BillingCity IN :citta
    ORDER BY Name
];
for (Account a : nord) {
    System.debug(a.Name);
}
