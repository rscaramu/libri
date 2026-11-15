AggregateResult r = [
    SELECT COUNT(Id) numero,
        SUM(AnnualRevenue) totale,
        AVG(AnnualRevenue) media,
        MAX(AnnualRevenue) massimo
    FROM Account
    WHERE BillingCountry = 'Italia'
];
System.debug(r.get('numero'));
System.debug(((Decimal) r.get('totale')).setScale(0));
System.debug(((Decimal) r.get('media')).setScale(0));
System.debug(((Decimal) r.get('massimo')).setScale(0));
