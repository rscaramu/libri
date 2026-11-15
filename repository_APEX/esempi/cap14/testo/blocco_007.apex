List<Opportunity> prossime = [
    SELECT Name, Amount
    FROM Opportunity
    WHERE CloseDate = NEXT_N_DAYS:60
        AND Account.BillingCountry = 'Italia'
    ORDER BY CloseDate
];
for (Opportunity o : prossime) {
    System.debug(o.Name + ': ' + o.Amount);
}
