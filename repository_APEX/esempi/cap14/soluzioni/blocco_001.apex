for (Contact c : [SELECT FirstName, LastName
        FROM Contact
        WHERE MailingCountry = 'Italia'
        AND Title = 'Titolare'
        ORDER BY LastName]) {
    System.debug(c.FirstName + ' ' + c.LastName);
}
