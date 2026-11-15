for (Account a : [SELECT Name,
            (SELECT Name FROM Opportunities
                WHERE IsClosed = false ORDER BY Name)
        FROM Account
        WHERE BillingCountry = 'Italia'
        ORDER BY Name]) {
    List<String> nomi = new List<String>();
    for (Opportunity o : a.Opportunities) {
        nomi.add(o.Name);
    }
    System.debug(a.Name + ': ' + nomi);
}
