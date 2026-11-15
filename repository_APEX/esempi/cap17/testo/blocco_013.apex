List<Opportunity> aperte = [
    SELECT Id, Amount FROM Opportunity
    WHERE IsClosed = false
        AND Account.BillingCountry = 'Italia'
];
for (Opportunity o : aperte) {
    o.Amount = (o.Amount * 1.10).setScale(2);
}
update aperte;
AggregateResult r = [SELECT SUM(Amount) tot
    FROM Opportunity WHERE IsClosed = false
    AND Account.BillingCountry = 'Italia'];
System.debug(((Decimal) r.get('tot')).setScale(0));
for (Opportunity o : aperte) {
    o.Amount = (o.Amount / 1.10).setScale(2);
}
update aperte;
