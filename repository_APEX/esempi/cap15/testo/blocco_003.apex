List<Account> aziende = [
    SELECT Name,
        (SELECT LastName FROM Contacts
            ORDER BY LastName)
    FROM Account
    WHERE BillingCountry = 'Italia'
    ORDER BY Name
];
for (Account a : aziende) {
    List<String> cognomi = new List<String>();
    for (Contact c : a.Contacts) {
        cognomi.add(c.LastName);
    }
    System.debug(a.Name + ': ' + cognomi);
}
