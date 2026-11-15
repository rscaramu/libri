List<AggregateResult> importanti = [
    SELECT Account.Name azienda, SUM(Amount) totale
    FROM Opportunity
    WHERE Account.BillingCountry = 'Italia'
    GROUP BY Account.Name
    HAVING SUM(Amount) > 120000
    ORDER BY Account.Name
];
for (AggregateResult riga : importanti) {
    System.debug(riga.get('azienda'));
}
