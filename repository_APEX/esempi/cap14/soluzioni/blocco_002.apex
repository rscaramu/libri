System.debug([SELECT COUNT() FROM Opportunity
    WHERE Amount > 50000
    AND Account.BillingCountry = 'Italia']);
