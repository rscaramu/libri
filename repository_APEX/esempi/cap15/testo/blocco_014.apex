List<Opportunity> aperte = [
    SELECT Name, Account.Name, Account.BillingCity
    FROM Opportunity
    WHERE IsClosed = false
        AND Account.BillingCountry = 'Italia'
    ORDER BY Name
];
for (Opportunity o : aperte) {
    System.debug(o.Name + ' - ' + o.Account.Name
        + ' (' + o.Account.BillingCity + ')');
}
