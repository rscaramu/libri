List<Account> lette = [
    SELECT Name, AnnualRevenue, Phone
    FROM Account
    WHERE BillingCountry = 'Italia'
];
SObjectAccessDecision decisione =
    Security.stripInaccessible(
        AccessType.READABLE, lette);
List<Account> pulite =
    (List<Account>) decisione.getRecords();
System.debug(pulite.size());
System.debug(decisione.getRemovedFields());
