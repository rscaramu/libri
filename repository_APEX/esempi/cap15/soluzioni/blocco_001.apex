for (Contact c : [SELECT LastName, Title,
            Account.Industry
        FROM Contact
        WHERE MailingCountry = 'Italia'
        AND AccountId != null
        ORDER BY LastName]) {
    System.debug(c.LastName + ' - ' + c.Title
        + ' - ' + c.Account.Industry);
}
