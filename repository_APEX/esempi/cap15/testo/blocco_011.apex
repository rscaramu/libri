List<AggregateResult> perAnno = [
    SELECT CALENDAR_YEAR(CloseDate) anno,
        COUNT(Id) numero
    FROM Opportunity
    WHERE Account.BillingCountry = 'Italia'
    GROUP BY CALENDAR_YEAR(CloseDate)
    ORDER BY CALENDAR_YEAR(CloseDate)
];
Integer totale = 0;
for (AggregateResult riga : perAnno) {
    totale += (Integer) riga.get('numero');
}
System.debug(totale);
