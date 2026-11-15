List<Contact> persone = [
    SELECT LastName, Account.Name, Account.BillingCity
    FROM Contact
    WHERE MailingCountry = 'Italia'
    ORDER BY LastName
];
for (Contact c : persone) {
    System.debug(c.LastName + ': '
        + (c.Account?.Name ?? 'nessuna azienda'));
}
