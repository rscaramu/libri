public class RicercaAziende {

    private static final Set<String> ORDINAMENTI =
        new Set<String>{ 'Name', 'AnnualRevenue',
            'BillingCity' };

    public static List<Account> cerca(String citta,
            Decimal fatturatoMinimo, String ordine) {
        List<String> condizioni = new List<String>{
            'BillingCountry = \'Italia\'' };
        Map<String, Object> valori =
            new Map<String, Object>();
        if (String.isNotBlank(citta)) {
            condizioni.add('BillingCity = :citta');
            valori.put('citta', citta);
        }
        if (fatturatoMinimo != null) {
            condizioni.add('AnnualRevenue >= :minimo');
            valori.put('minimo', fatturatoMinimo);
        }
        String campoOrdine =
            ORDINAMENTI.contains(ordine) ? ordine : 'Name';
        String testo = 'SELECT Name, BillingCity,'
            + ' AnnualRevenue FROM Account WHERE '
            + String.join(condizioni, ' AND ')
            + ' ORDER BY ' + campoOrdine
            + ' LIMIT 50';
        return Database.queryWithBinds(testo, valori,
            AccessLevel.SYSTEM_MODE);
    }
}
