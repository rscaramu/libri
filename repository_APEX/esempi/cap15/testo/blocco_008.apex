List<AggregateResult> perFase = [
    SELECT StageName fase, COUNT(Id) numero,
        SUM(Amount) totale
    FROM Opportunity
    WHERE Account.BillingCountry = 'Italia'
    GROUP BY StageName
    ORDER BY SUM(Amount) DESC
];
for (AggregateResult riga : perFase) {
    System.debug(riga.get('fase') + ': '
        + riga.get('numero') + ' - '
        + ((Decimal) riga.get('totale')).setScale(0));
}
