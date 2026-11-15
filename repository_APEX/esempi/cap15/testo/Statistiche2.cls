public class Statistiche2 {

    public static Map<String, Integer> aziendePerCitta() {
        Map<String, Integer> esito =
            new Map<String, Integer>();
        for (AggregateResult riga : [
                SELECT BillingCity citta, COUNT(Id) n
                FROM Account
                WHERE BillingCountry = 'Italia'
                GROUP BY BillingCity
                ORDER BY BillingCity]) {
            esito.put((String) riga.get('citta'),
                (Integer) riga.get('n'));
        }
        return esito;
    }
}
