public with sharing class ElencoAziende {

    public static List<Account> italiane() {
        return [
            SELECT Name, AnnualRevenue
            FROM Account
            WHERE BillingCountry = 'Italia'
            WITH USER_MODE
            ORDER BY Name
        ];
    }
}
