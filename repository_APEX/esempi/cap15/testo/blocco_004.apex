Account a = [
    SELECT Name,
        (SELECT LastName FROM Contacts),
        (SELECT Name FROM Opportunities
            WHERE StageName = 'Closed Won')
    FROM Account
    WHERE Name = 'Energia Blu'
    LIMIT 1
];
System.debug(a.Contacts.size());
System.debug(a.Opportunities.size());
