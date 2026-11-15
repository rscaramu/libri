public with sharing class AziendeRipulite {

    public static List<Account> italiane() {
        SObjectAccessDecision decisione =
            Security.stripInaccessible(
                AccessType.READABLE, [
                    SELECT Name, AnnualRevenue,
                        NumberOfEmployees
                    FROM Account
                    WHERE BillingCountry = 'Italia']);
        System.debug(decisione.getRemovedFields());
        return (List<Account>) decisione.getRecords();
    }
}
