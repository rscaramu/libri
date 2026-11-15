Decimal totale = 0;
for (Opportunity o : [SELECT Amount FROM Opportunity
        WHERE StageName = 'Closed Won'
        AND Account.BillingCountry = 'Italia']) {
    totale += o.Amount;
}
System.debug(totale);
