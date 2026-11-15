public class AziendePerCitta {

    public static List<Account> cerca(
            List<String> citta) {
        return [
            SELECT Name, BillingCity FROM Account
            WHERE BillingCountry = 'Italia'
                AND BillingCity IN :citta
            ORDER BY Name
        ];
    }
}
