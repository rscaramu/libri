AggregateResult r = [
    SELECT AVG(Amount) media, MIN(Amount) minimo,
        MAX(Amount) massimo
    FROM Opportunity
    WHERE Account.BillingCountry = 'Italia'];
System.debug(((Decimal) r.get('media')).setScale(2));
System.debug(((Decimal) r.get('minimo')).setScale(0));
System.debug(((Decimal) r.get('massimo')).setScale(0));
