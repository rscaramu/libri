List<Account> aziende = [
    SELECT Name,
        (SELECT Id FROM Contacts),
        (SELECT Amount FROM Opportunities
            WHERE IsWon = true)
    FROM Account
    WHERE BillingCountry = 'Italia'
    ORDER BY Name
];
for (Account a : aziende) {
    Decimal vinto = 0;
    for (Opportunity o : a.Opportunities) {
        vinto += o.Amount;
    }
    System.debug(a.Name + ': ' + a.Contacts.size()
        + ' contatti, vinto ' + vinto.setScale(0));
}
