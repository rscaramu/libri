List<AggregateResult> perAzienda = [
    SELECT Account.Name azienda, SUM(Amount) totale
    FROM Opportunity
    WHERE Account.BillingCountry = 'Italia'
    GROUP BY Account.Name
    ORDER BY Account.Name
];
for (AggregateResult riga : perAzienda) {
    System.debug(riga.get('azienda') + ': '
        + ((Decimal) riga.get('totale')).setScale(0));
}
