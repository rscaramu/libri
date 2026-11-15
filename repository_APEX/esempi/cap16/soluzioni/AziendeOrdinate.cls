public class AziendeOrdinate {

    public static List<Account> elenco(String campo,
            String verso) {
        Map<String, Schema.SObjectField> campi =
            Account.sObjectType.getDescribe()
                .fields.getMap();
        String ordine = campi.containsKey(campo)
            ? campi.get(campo).getDescribe().getName()
            : 'Name';
        String direzione =
            'DESC'.equalsIgnoreCase(verso) ? 'DESC' : 'ASC';
        return Database.query(
            'SELECT Name FROM Account'
            + ' WHERE BillingCountry = \'Italia\''
            + ' ORDER BY ' + ordine + ' ' + direzione);
    }
}
