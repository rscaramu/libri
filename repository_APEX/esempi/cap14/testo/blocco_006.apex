for (Account a : [SELECT Name FROM Account
        WHERE Name LIKE 'T%'
        AND BillingCountry = 'Italia'
        ORDER BY Name]) {
    System.debug('LIKE: ' + a.Name);
}
for (Account a : [SELECT Name FROM Account
        WHERE BillingCity IN ('Bari', 'Lecce')
        ORDER BY Name]) {
    System.debug('IN: ' + a.Name);
}
for (Account a : [SELECT Name FROM Account
        WHERE Rating = null
        AND BillingCountry = 'Italia']) {
    System.debug('NULL: ' + a.Name);
}
