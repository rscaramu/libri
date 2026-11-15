for (Opportunity o : [SELECT Name FROM Opportunity
        WHERE IsClosed = true
        AND CloseDate = LAST_N_DAYS:90
        AND Account.BillingCountry = 'Italia'
        ORDER BY Name]) {
    System.debug(o.Name);
}
