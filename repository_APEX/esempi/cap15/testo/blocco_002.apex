List<Opportunity> trattative = [
    SELECT Name, Account.Name, Account.Owner.Name
    FROM Opportunity
    WHERE Account.BillingCity = 'Bari'
    ORDER BY Account.Name, Name
];
for (Opportunity o : trattative) {
    System.debug(o.Account.Name + ' - ' + o.Name);
}
